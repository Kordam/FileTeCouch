part of test_file_te_couch;


void test_db_object_id_basic() {
  test("new DBObjectId().toString() is not null", () {
    expect(new DBObjectId().toString(), isNotNull);
    expect(new DBObjectId().toString(), isNot(isEmpty));
   });
  test("new DBObjectId().toString() provide 2 random couchbase object ids", () {
     expect(new DBObjectId().toString(), isNot(equals(new DBObjectId().toString())));
   });
  test("new DBObjectId().toString() provide 100.000 random couchbase object ids", () {
     int nbrIds = 100000;

     LinkedHashSet<String> ids = new LinkedHashSet<String>();
     for (var i = 0; i < nbrIds; ++i)
       ids.add(new DBObjectId().toString());
    
     expect(ids.length, equals(nbrIds));
   });
}


void test_db_object_id_width_prefix() {
  test("new DBObjectId(prefix: '<your prefix>').toString() provide id with prefix", () {
     expect(new DBObjectId(prefix: "prefix").toString(), startsWith("prefix_"));
   });
}
