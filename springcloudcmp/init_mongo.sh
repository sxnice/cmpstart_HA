#!/bin/bash
source ~/.bashrc
mongo $1:31001 <<-EOSQL 
	rs.initiate({_id:"dbReplSet",members:[{_id:0,host:"$1:31001",priority:2},{_id:1,host:"$2:31001",priority:1},{_id:2,host:"$3:31001",arbiterOnly: true}]});
	rs.status();
EOSQL
sleep 20
mongo $1:31001 <<-EOSQL
	use collectDataDB;
	db.createUser(
        {
          user: "root",
          pwd: "$4",
          roles: [ { role: "root", db: "admin" } ]
        }
     );
	 db.auth('root','$4');
EOSQL
