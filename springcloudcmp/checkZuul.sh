PRG="$0"
portzuulmanager=20892

while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done
PRGDIR=`dirname "$PRG"`
  
CURRENT_DIR=`cd "$PRGDIR" >/dev/null; pwd`


#启动zuulmanager
if [ "$nodeplan" = "1" ] || [ "$nodetype" = "1" -a "$nodeplan" = "2" -a "$nodeno" = "2" ] || [ "$nodetype" = "1" -a "$nodeplan" = "3" -a "$nodeno" = "2" ] || [ "$nodetype" = "1" -a "$nodeplan" = "4" -a "$nodeno" = "3" ] || [ "$nodetype" = "3" -a "$nodeplan" = "2" -a "$nodeno" = "2" ] || [ "$nodetype" = "3" -a "$nodeplan" = "3" -a "$nodeno" = "2" ] || [ "$nodetype" = "3" -a "$nodeplan" = "4" -a "$nodeno" = "3" ]; then
echo "start zuulmanager"	
pIDzuulmanager=`lsof -i :$portzuulmanager|grep  "LISTEN" | awk '{print $2}'`


if [ "$pIDzuulmanager" = "" ] ; then
	keepalivedcheck=$(ps -C keepalived --no-header | wc -l)
	if [ "${keepalivedcheck}" != "0" ]; then
	  /etc/init.d/keepalived stop
	else
	  echo "keepalived is stoped"
	fi
fi

fi

