#!/bin/sh


sleep 40
echo '{"time":"29-Aug-2020 10:50:17","text":"Error Loading Geometry Info","type":"error"}'>> $4
echo '{"version":"20180831","author":"eros.montin@gmail.com","type":"DATA","subtype":""}' >> $3
touch $6
#mimik camrie work
#runcamrie.sh MCR /app/testoptions.json /camrieTemp/output.json /camrieTemp/l.json /camrieTemp/ /camrieTemp/a.mat
