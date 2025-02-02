#!/bin/bash
set -e

#Color to the people
RED='\x1B[0;31m'
CYAN='\x1B[0;36m'
GREEN='\x1B[0;32m'
NC='\x1B[0m'

function rebuild {
    sudo docker build docker/node/ -t onefinity:testnet --no-cache
    sudo docker build docker/mxpy/ -t mxpy:latest --no-cache
    echo -e "${GREEN} Done rebuilding containers${NC}"
}

function stop_nodes {
    echo -e "Stop the nodes"
    echo -e "- Clearing existing docker templates"
    rm *.node.yml -f
    echo -e "${GREEN}- Clearing docker templates done!${NC}"
    node_number=0

    for dir in ./volumes/*/ ; do

        node_name="$(basename $dir)"
        echo -e "- Generating docker file for $node_name"

        port=$((8081+$node_number))
        sed 's/<node-name>/'"$node_name"'/g' node.yml.tmpl > $node_name.node.yml
        node_number=$node_number+1
        echo -e "${GREEN}- Generating docker file for $node_name done!${NC}"
    done

    compose_args=" "
    for dir in ./*.node.yml ; do
        compose_args="$compose_args -f $(basename $dir)"
    done
    echo -e ""
    echo -e "Start docker-compose with this command:"
    echo -e "docker compose $compose_args stop"
    echo -e ""
    docker compose $compose_args stop
    echo -e ""
    echo -e "${GREEN}Nodes stopped${NC}"
    echo -e ""

}
function create_node {
    echo -e
    echo -e "${GREEN} Nodes are named to their assigned shard${NC}"
    echo -e
    NODE_NAME="onefinity-validator-$INDEX"
    sudo cp ../onefinity-validator-src/onefinity/config/ volumes/$NODE_NAME/ -rf

    mkdir -p ./volumes/$NODE_NAME/keys/
    
    echo -e "${GREEN} Generated directory for node $NODE_NAME${NC}"



}

case "$1" in
'rebuild')
    rebuild
;;
'initial-install')
    git clone https://github.com/buidly/onefinity-testnet-validators ~/git-testnet
;;

'setup')

    echo -e "${GREEN} Start of initialising the nodes for this multikey setup ${NC}"
    echo -e ""
    read -p "Every shard get one node assigned, How many shards are there ? : " NUMBEROFNODES
    re='^[0-9]+$'
    if ! [[ $NUMBEROFNODES =~ $re ]] && [ "$NUMBEROFNODES" -gt 0 ]
    then
        NUMBEROFNODES = 1
    fi

    for i in $(seq 1 $NUMBEROFNODES);
    do
        INDEX=$(( $i - 1 ))
        create_node
    done
    echo -e ""
    echo -e "${GREEN} Initialising done${NC}"
    sudo chown -R 1000:1000 volumes/
;;
'stop')
 stop_nodes
;;
'build')
    echo -e ""
    echo -e ""
    echo -e "The container needs to be built for the first time, which may take a few minutes." 
    echo -e ""
    rebuild
;;
'start')
    echo -e "Start the nodes"
    echo -e "- Clearing docker templates"
    rm *.node.yml -f
    echo -e "${GREEN}- Clearing docker templates done!${NC}"
    node_number=0

    for dir in ./volumes/*/ ; do

        node_name="$(basename $dir)"
        echo -e "- Generating docker file for $node_name"
        sed 's/<node-name>/'"$node_name"'/g' node.yml.tmpl > $node_name.node.yml      
        node_number=$node_number+1
        echo -e "${GREEN}- Generating docker file for $node_name done!${NC}"
    done

    compose_args=" "
    for dir in ./*.node.yml ; do
        compose_args="$compose_args -f $(basename $dir)"
    done
    sudo chown -R 1000:1000 volumes
    echo -e ""
    echo -e "Start docker-compose with this command:"
    echo -e "docker compose $compose_args up -d  --remove-orphans"
    echo -e ""
    docker compose $compose_args up -d  --remove-orphans
    echo -e ""
    echo -e "${GREEN}Nodes started in the background${NC}"
    echo -e ""
;;
'clear')
    echo -e ""
    echo -e "Start of clearing the nodes data and configs, only leaving the keys in place."
    stop_nodes
    for dir in ./volumes/*/ ; do
        node_name="$(basename $dir)"
        echo -e "- Clearing data and config fir $node_name"
        rm volumes/$node_name/working-dir -rf
    done 
    echo -e "${GREEN} Done clearing containers ${NC}"
;;
'remove-node')
    echo -e ""
    echo -e "To remove node, just delete the subdirectory in the ./volumes directory and run ./script start"
    echo -e ""
;;
*)
  echo "Usage: Missing parameter ! [initial-install|setup|start|stop|build|rebuild|clear|remove-node]|"
  ;;
esac
