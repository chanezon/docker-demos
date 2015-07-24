#!/bin/bash
start=`date +%s`
case "$1" in
        create)
		    if [[ ! `docker-machine ip swarm-master` ]]; then
		        docker-machine create \
				    -d virtualbox \
				    --swarm \
				    --swarm-master \
				    --swarm-discovery "nodes://192.168.98.[100:110]:2376" \
				    --virtualbox-hostonly-cidr=192.168.98.1/24 \
				    swarm-master
		    fi
		    if [[ ! `docker-machine ip swarm-node-00` ]]; then
				docker-machine create \
					    -d virtualbox \
					    --swarm \
					    --swarm-discovery "nodes://192.168.98.[100:110]:2376" \
					    --virtualbox-hostonly-cidr="192.168.98.1/24" \
					    swarm-node-00
		    fi
		    docker-machine restart swarm-master
			eval $(docker-machine env --swarm swarm-master)
			docker info
            ;;
        delete)
			docker-machine rm swarm-master
			docker-machine rm swarm-node-00
            ;;
        start)
			docker-machine start swarm-master
			docker-machine start swarm-node-00
            ;;
        stop)
			docker-machine stop swarm-master
			docker-machine stop swarm-node-00
            ;;
        *)
            echo $"Usage: $0 {start|stop|create|delete|status}"
            exit 1
esac
end=`date +%s`
echo "done in " `expr $end - $start` "s"
