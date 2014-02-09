royal-invoicing
===============

##*Royal Invoicing* helps you manage your invoices and estimates.

###There's a few features here, which can be valuable for organizing your finances:

- create a contact
- create an estimate
- create an invoice
- sort estimates/invoices by due date, expense, etc.
- email out invoices to client

So what you have is a record of your invoices, the total expenses, and even your own little contact-book.

##** Getting Started **

1. After clone the repo, make your own database.yml. I left an example that you can copy/paste/modify, but feel free to make your own.
2. Bundle
3. Create/Migrate the database.
4. The current email feature requires you have a Mandrill API key. However, you can also configure *setup_mail.rb* and use gmail instead of Mandrill.
5. Boot up local host and enjoy!