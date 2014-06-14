#!/bin/bash
DIR=$(dirname $(readlink -f $0)) ;

echo -n "Checking 'mysql' CLI .. "
if command -v mysql >/dev/null 2>&1; then
   echo "ok"
else
   echo "failure"
   exit 1
fi;

echo ""
echo -n "Enter database, to which mysql-unit will be installed: "
read DATABASE
echo -n "Enter user name, which will execute install scripts: "
read USERNAME
echo -n "Enter password for $USERNAME : "
read -s PASSWORD

echo ""
echo -n "Checking '$USERNAME' generic access .. "
if `mysql -u $USERNAME -p$PASSWORD $DATABASE -e "" >/dev/null 2>&1`; then
   echo "ok"
else
   echo "failure"
   echo "Installation failed: user '$USERNAME' has no access to database '$DATABASE' or password was wrong"
   exit 1
fi;

echo ""
echo "Installing tests storage"

for sqlFile in `ls $DIR/../../Storage/Main/*.sql`; do 
   echo -n "Processing: $sqlFile .. "; 
   if `mysql -u $USERNAME -p$PASSWORD $DATABASE < $sqlFile >/dev/null 2>&1`; then
      echo "ok"
   else
      echo "failure"
      echo "Installation failed: SQL command failed for user '$USERNAME' on database '$DATABASE' for file $sqlFile"
      exit 1
fi;
done

echo ""
echo "Installing tests API"

for sqlFile in `ls $DIR/../../Invoke/*/*.sql`; do 
   echo -n "Processing: $sqlFile .. "; 
   if `mysql -u $USERNAME -p$PASSWORD $DATABASE < $sqlFile >/dev/null 2>&1`; then
      echo "ok"
   else
      echo "failure"
      echo "Installation failed: SQL command failed for user '$USERNAME' on database '$DATABASE' for file $sqlFile"
      exit 1
fi;
done

echo ""
echo "mysql-unit successfully installed into database '$DATABASE'"
echo ""
echo "Thank you for using mysql-unit"
echo ""
echo "Please, send feedback to <eugen.alter@gmail.com>"
echo ""
