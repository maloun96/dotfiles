#!/bin/zsh
echo "Re-registering Valet proxies with TLS (--secure). sudo will prompt once."
echo
for p in idp.sip:8791 app.sip:8793 control.sip:8794 billing.sip:8795 payments.sip:8796 \
         numbers.sip:8797 crm.sip:8787 monitor.sip:8788 pbx.sip:3000 workspace.sip:8703 \
         events.sip:8704 chat.sip:8706 dashboard.sip:5175 fraud.sip:5176 \
         spanvox.sip:8798 spanvox-admin.sip:5178
do
  valet proxy "${p%%:*}" "http://127.0.0.1:${p##*:}" --secure
done
echo
echo "=== valet proxies ==="
valet proxies
