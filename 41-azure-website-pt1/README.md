 Describe how you would:
○ Validate and register your custom domain in Azure DNS?

Iw would create an Azure DNS Zone and update my domain registrar with the Name Servers provided by Azure. To prove I actually own the domain, I would add a TXT record as part of the validation process in the portal. Once Azure confirms the record, the domain is officially registered and ready to use.

○ Acquire or import an SSL/TLS certificate in Azure CDN (Custom domain
HTTPS)

To keep the site secure, I’d enable HTTPS in the CDN settings for my custom domain. I would choose the "CDN-managed" option because it's free and Azure handles the certificate renewal automatically. If I had to use my own certificate, I’d just upload it to Azure Key Vault and link it to the CDN endpoint.

○ Create a CNAME record so that www.example.com points to your CDN
endpoint

I’d go into my DNS settings and create a CNAME record with www as the host name. I would point it to my technical CDN address, which is the one ending in .azureedge.net. This creates an alias so that anyone typing my custom URL gets sent directly to the CDN.

○ List the Azure resources/modules you’d use and a brief config sketch.

I would use a Resource Group to hold a Storage Account with "Static website" hosting enabled for the $web container. I'd also need a CDN Profile and an Endpoint pointing to that storage account as its origin. Finally, I'd use a DNS Zone to manage the CNAME and TXT records to tie the domain to the site
