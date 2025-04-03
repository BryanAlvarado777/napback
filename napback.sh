#!/bin/bash

## pasar como parametro ruta completa de archivos
## bash napback.sh /path/to/instance.opb

if [ "$#" -eq 1 ]; then
    # Only the instance is passed; infer the other filenames.
    instance=$1
    cnf="${instance}.cnf"
    backbone_cnf="${instance}.backbone_cnf"
    backbone="${instance}.backbone"
    log="${instance}.log"
    var_map="${instance}.var_map"
elif [ "$#" -eq 6 ]; then
    # All arguments provided
    instance=$1
    cnf=$2
    backbone_cnf=$3
    backbone=$4
    log=$5
    var_map=$6
else
    echo "Usage:"
    echo "  $0 <instance_file>   (inferred: ${instance}.cnf, ${instance}.backbone_cnf, ${instance}.backbone, ${instance}.log, ${instance}.var_map)"
    echo "  OR"
    echo "  $0 <instance_file> <cnf_file> <backbone_cnf_file> <backbone_file> <log_file> <var_map_file>"
    exit 1
fi


echo "Starting conversion cnf->opb with NAPS" >> "$log"
/naps/naps_bignum_static -cnf="$cnf" "$instance" >> "$log"

echo "Saving variable map" >> "$log"
tac $cnf | grep -m1 '^cv' > "$var_map"

echo "Starting extraction of backbone from cnf with CADIBACK" >> "$log"
/cadiback/cadiback "$cnf" "$backbone_cnf" >> "$log"

echo "Starting backbone conversion cnf->opb with NAPS" >> "$log"
python3 /scripts/cnf_backbones_to_pbo.py "$var_map" "$backbone_cnf" "$backbone" >> "$log"

echo "END" >> "$log"
