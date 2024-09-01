#!/bin/bash

while true; do
    echo "*** Inserisci comando per gestire le slice (ATTIVA TUTTO, DISATTIVAx, ATTIVAx) con x numero della slice compreso tra 1 e 4: "
    read comando

    comando=$(echo $comando | tr '[:lower:]' '[:upper:]')

    case $comando in
        DISATTIVA1)
            echo "*** Spegnimento della slice 1"
            bash ./slice_script/slice1.sh
            ;;
        DISATTIVA2)
            echo "*** Spegnimento della slice 2"
            bash ./slice_script/slice2.sh
            ;;
        DISATTIVA3)
            echo "*** Spegnimento della slice 3"
            bash ./slice_script/slice3.sh
            ;;
        DISATTIVA4)
            echo "*** Spegnimento della slice 4"
            bash ./slice_script/slice4.sh
            ;;
        ATTIVA1)
            echo "*** Attivazione della slice 1"
            bash ./slice_script/attiva_slice1.sh
            ;;
        ATTIVA2)
            echo "*** Attivazione della slice 2"
            bash ./slice_script/attiva_slice2.sh
            ;;
        ATTIVA3)
            echo "*** Attivazione della slice 3"
            bash ./slice_script/attiva_slice3.sh
            ;;
        ATTIVA4)
            echo "*** Attivazione della slice 4"
            bash ./slice_script/attiva_slice4.sh
            ;;
        "ATTIVA TUTTO")
            echo "*** Attivazione di tutte le slice"
            bash ./slice_script/attiva_slicing.sh
            ;;
        *)
            echo "*** Comando non riconosciuto! Usa DISATTIVA1, DISATTIVA2, DISATTIVA3, DISATTIVA4, ATTIVA1, ATTIVA2, ATTIVA3, ATTIVA4, ATTIVA TUTTO"
            ;;
    esac
done
