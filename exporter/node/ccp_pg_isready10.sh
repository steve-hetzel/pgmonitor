#!/usr/bin/env bash

PGDIR=/var/lib/ccp_monitoring/node_exporter
PGTMP=is_pgready-10.tmp
PGFILE=is_pgready-10.prom
PGBIN=/usr/pgsql-10/bin
if [ ! -d ${PGDIR} ]; then
  mkdir ${PGDIR}
fi
rm -f ${PGDIR}/${PGTMP}
$PGBIN/pg_isready -d postgres >/dev/null
EX_VAL=$?
if [ $EX_VAL -eq  0 ]; then
	REC=$(psql -d postgres -Atc 'select pg_is_in_recovery()')
	if [ "$REC" = "f" ]; then
		echo "ccp_pg_ready 2" >>${PGDIR}/${PGTMP}
	else
		echo "ccp_pg_ready 1" >>${PGDIR}/${PGTMP}
	fi
else
	echo "ccp_pg_ready 0" >>${PGDIR}/${PGTMP}
fi
mv ${PGDIR}/${PGTMP} ${PGDIR}/${PGFILE}
