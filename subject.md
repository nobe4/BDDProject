Requirements
------------
Java application 
Oracle DB 

buy products, stock it in a container and sell it to clients
BDD used to :
	1 trace all buy and sell
	2 show current capacity/possiblity and stock

Supplier
--------
a supplier is identified by name and described by adress and phone number
a supplier can sell multiple products which are identified by their name

Product
-------
the same product can be sold by two wholesalers
a product has a fixed price that can be negociated

Client
------	
same as a supplier
can has multiple shipping adresses different from their main adress

Wholesaler
----------
sell:
	- clothes described by color and size
	- food described by the peremption date
		- some has to be freezed at some temperature

Product
-------
many are identified by group number attribued by the supplier
each supplier has unique group number on every of his group but 2 suppliers can have the same groupe number
wholesaler must follow the group number from buy to sell

Repository
----------
identified by adress 
can store multiple types of products
has a capacity and possibility storage
many has cold chamber

Wholesaler command
------------------
a wholesaler to the unique supplier
can be on multiple products
described by product :
	- quantity
	- negociated price
has a unique number in the account book of the supplier

Client command
--------------
has the shipping adress 
identified by a number which is unique in all clients commands
