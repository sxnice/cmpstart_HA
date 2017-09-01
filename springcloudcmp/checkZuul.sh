PRG="$0"
portzuulmanager=20892
sleeptime=2

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

echo "nodeplan=""$nodeplan"
echo "nodetype=""$nodetype"
echo "nodeno=""$nodeno"

if [ "$nodeplan" = "1" ] || [ "$nodetype" = "1" -a "$nodeplan" = "2" -a "$nodeno" = "2" ] || [ "$nodetype" = "1" -a "$nodeplan" = "3" -a "$nodeno" = "2" ] || [ "$nodetype" = "1" -a "$nodeplan" = "4" -a "$nodeno" = "3" ] || [ "$nodetype" = "3" -a "$nodeplan" = "2" -a "$nodeno" = "2" ] || [ "$nodetype" = "3" -a "$nodeplan" = "3" -a "$nodeno" = "2" ] || [ "$nodetype" = "3" -a "$nodeplan" = "4" -a "$nodeno" = "3" ]; then
#启动zuulmanager
echo "start zuulmanager"	
pIDzuulmanager=`lsof -i :$portzuulmanager|grep  "LISTEN" | awk '{print $2}'`
echo $pIDzuulmanager 
if [ "$pIDzuulmanager" = "" ] ; then

nohup "$CURRENT_DIR"/background/springbootstartzuulmanager.sh &>/dev/null &
fi
while [ "$pIDzuulmanager" = "" ]
  do
  sleep $sleeptime
  pIDzuulmanager=`lsof -i :$portzuulmanager|grep  "LISTEN" | awk '{print $2}'`
  echo $pIDzuulmanager &>/dev/null &
  echo -n "."
done
echo "zuulmanager success!"


sleep $sleeptime
# 如果上面无法启动成功，那么就停止keepalived
if [ "$pIDzuulmanager" = "" ] ; then
	keepalivedcheck=$(ps -C keepalived --no-header | wc -l)
	if [ "${keepalivedcheck}" != "0" ]; then
	  /etc/init.d/keepalived stop
	else
	  echo "keepalived is stoped"
	fi
fi

fi

