CREATE SCHEMA nodetemplateprojectdatabasenamespace;

CREATE TABLE "nodetemplateprojectdatabasenamespace"."schemaupgrade" (
	"time" TIMESTAMP,
	"scriptfilename" VARCHAR(255),
	"scriptfilehash" CHAR(40)
);
