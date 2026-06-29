#!/bin/bash

# Se o script for chamado com o argumento "internal-run", ele executa a lógica como root
if [ "$1" == "internal-run" ]; then
    STATUS=$(ufw status | grep -o "active\|inactive")

    # Resgata o endereço do D-Bus do seu usuário para o root conseguir enviar a notificação
    USER_DBUS_ADDRESS="unix:path=/run/user/$PKEXEC_UID/bus"

    if [ "$STATUS" == "active" ] || [ "$STATUS" == "ativo" ]; then
        ufw disable
        sudo -u "#$PKEXEC_UID" DBUS_SESSION_BUS_ADDRESS="$USER_DBUS_ADDRESS" notify-send "Firewall" "UFW foi desativado" -i network-firewall
    else
        ufw enable
        sudo -u "#$PKEXEC_UID" DBUS_SESSION_BUS_ADDRESS="$USER_DBUS_ADDRESS" notify-send "Firewall" "UFW foi ativado" -i network-firewall
    fi
    exit 0
fi

# Se for chamado normalmente (pelo Noctalia), ele chama a si mesmo via pkexec
pkexec "$0" internal-run