library FileTeCouch;

import "dart:convert";
import "dart:async";
import "dart:io";
import "dart:math" show Random;

// $> pub install
import 'package:yaml/yaml.dart';

// rikulo clients
import "package:couchclient/couchclient.dart";
import "package:memcached_client/memcached_client.dart";




/**
 * LIBRARY
 */

// main object
part 'src/file_te_couch.dart';

// db connection
part "src/couchbase_cluster.dart";

// bucket implementation
part 'src/bucket_access/bucket_access.dart';
part 'src/bucket_access/bucket_access_couchbase.dart';
part "src/bucket_access/bucket_access_memcached.dart";

// I/O views object
part "src/views/db_query.dart";
part "src/views/view_object.dart";

// I/O object
part "src/db_object/db_object.dart";
part 'src/db_object/db_object_id.dart';


