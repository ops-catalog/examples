
create keyspace if not exists customer with replication={'class':'SimpleStrategy', 'replication_factor':1};

DROP TABLE IF EXISTS customer.catalog;

CREATE TABLE IF NOT EXISTS customer.catalog (
    ID text primary key,
    CONTENT BLOB
) WITH
comment = '{
  "discovery.ops.catalog/skip": "false",
  "discovery.ops.catalog/team": "onlineaccess",
  "discovery.ops.catalog/domain": "servicing",
  "discovery.ops.catalog/capability": "storage",
  "discovery.ops.catalog/description": "Keyspace to house tables storing customer engagement data"
}';

create keyspace if not exists payment with replication={'class':'SimpleStrategy', 'replication_factor':1};

DROP TABLE IF EXISTS payment.catalog;

CREATE TABLE IF NOT EXISTS payment.catalog (
    ID text primary key,
    CONTENT BLOB
) WITH 
comment = '{
  "discovery.ops.catalog/skip": "false",
  "discovery.ops.catalog/team": "paypaynow", 
  "discovery.ops.catalog/domain": "payment",
  "discovery.ops.catalog/capability": "storage",
  "discovery.ops.catalog/includes": "payment-stuff",
  "discovery.ops.catalog/description": "Keyspace to house payment tables"
}';

