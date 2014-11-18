part of test_file_te_couch;


void test_db_object_ctor() {
  test("Constructor called with key and value parameters", () {
    expect(new DBObject("key", "value").toString(), equals('{key="key", value="value", _ttl=unlimited, revision=null}'));
  });
  test("Constructor called with not null key and value parameters", () {
    expect(new DBObject("key", "value").key, isNotNull);
    expect(new DBObject("key", "value").value, isNotNull);
    expect(new DBObject("key", "value").revision, isNull);
    expect(new DBObject("key", "value").ttl, isNull);
    expect(new DBObject("key", "value").key, isNot(isEmpty));
    expect(new DBObject("key", "value").value, isNot(isEmpty));
  });
  test("Constructor called with key, value, ttl and revision parameters", () {
    expect(new DBObject("key", "value", dbTtl: 10, dbRevision: 42).toString(), equals('{key="key", value="value", _ttl="10", revision="42"}'));
    expect(new DBObject("key", "value", dbTtl: 10, dbRevision: 42).revision, isNotNull);
    expect(new DBObject("key", "value", dbTtl: 10, dbRevision: 42).ttl, isNotNull);
  });
  test("Constructor called without key, but with value and prefix parameters", () {
    expect(new DBObject(null, "value", prefixNewId: "prefix").key, startsWith("prefix_"));
  });
  test("Constructor called with key with value and prefix parameters", () {
    expect(new DBObject("key", "value", prefixNewId: "prefix").key, isNot(startsWith("prefix_")));
  });
}

void test_db_object_GetResult_to_DBObject() {
  GetResult res1 = new GetResult("key", 0, 42, UTF8.encode(JSON.encode({"toto": 42})));
  GetResult res2 = new GetResult("key", 0, 42, UTF8.encode(JSON.encode({"tata": -42})));

  test("GetResult to DBObject", () {
    expect(DBObject.entryToDBObject(res1).toString(), equals('{key="key", value="{toto: 42}", _ttl=unlimited, revision="42"}'));
  });
  test("List<GetResult> to List<DBObject>", () {
    expect(DBObject.entriesToDBObject([res1, res2]).toString(), equals('[{key="key", value="{toto: 42}", _ttl=unlimited, revision="42"}, {key="key", value="{tata: -42}", _ttl=unlimited, revision="42"}]'));
  });
}
