# query puppet db
 
## setup puppet api access
 
 
1. On master...
2. Generate key
    a. puppet cert generate api
        b. You can call it anything .. api is just an example
3. Openssl to convert to pfx
    a. openssl pkcs12 -export -out /home/training/api-pupcert.pfx -inkey /etc/puppetlabs/puppet/ssl/private_keys/api.pem -in /etc/puppetlabs/puppet/ssl/certs/api.pem -certfile /etc/puppetlabs/puppet/ssl/certs/ca.pem
4. Copy the cert from the linux server to your windows box or wherever you need it
    a. Don't forget to change ownership if you are a linux newbie!
        i. chown <userid> <pfxfile>
5. On puppetdb
    a. vim /etc/puppetlabs/puppetdb/certificate-whitelist
    b. ( add the cert name you created) "api" is the example we used
6. Restart puppetdb
    a. service pe-puppetdb restart
7. On puppet console
    a.  vim /etc/puppetlabs/console-services/rbac-certificate-whitelist
    b. ( add the cert name you created)
8. Restart puppet console services
    a. service pe-console-services restart
9. Run the commands you need!
