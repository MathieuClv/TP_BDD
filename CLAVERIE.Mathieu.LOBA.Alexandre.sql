-- ------------------------------------------------------
-- NOTE: DO NOT REMOVE OR ALTER ANY LINE FROM THIS SCRIPT
-- ------------------------------------------------------

select 'Query 00' as '';
-- Show execution context
select current_date(), current_time(), user(), database();
-- Conform to standard group by constructs
set session sql_mode = 'ONLY_FULL_GROUP_BY';

-- Write the SQL queries that return the information below:
-- Ecrire les requêtes SQL retournant les informations ci-dessous:

select 'Query 01' as '';
-- The countries of residence the supplier had to ship products to in 2014
-- Les pays de résidence où le fournisseur a dû envoyer des produits en 2014
select distinct residence --s'il y a deux residences identiques les affiches t'ont ? ou UNIQUE ?
from customers
where not (residence is null); --ici on s'interrogera si la residence null doit etre affiche ?


select 'Query 02' as '';
-- For each known country of origin, its name, the number of products from that country, their lowest price, their highest price
-- Pour chaque pays d'orgine connu, son nom, le nombre de produits de ce pays, leur plus bas prix, leur plus haut prix
select origin, count(pid), max(price), min(price) from products group by origin where origin is not NULL; -- ne marche plus sur mon ordi jsp pk 

select 'Query 03' as '';
-- The customers who ordered in 2014 all the products (at least) that the customers named 'Smith' ordered in 2013
-- Les clients ayant commandé en 2014 tous les produits (au moins) commandés par les clients nommés 'Smith' en 2013


select 'Query 04' as '';
-- For each customer and each product, the customer's name, the product's name, the total amount ordered by the customer for that product,
-- sorted by customer name (alphabetical order), then by total amount ordered (highest value first), then by product id (ascending order)
-- Par client et par produit, le nom du client, le nom du produit, le montant total de ce produit commandé par le client, 
-- trié par nom de client (ordre alphabétique), puis par montant total commandé (plus grance valeur d'abord), puis par id de produit (croissant)


select 'Query 05' as '';
-- The customers who only ordered products originating from their country
-- Les clients n'ayant commandé que des produits provenant de leur pays
select distinct c.cname, c.residence as customers, p.origin as products 
from customers c right outer join products p 
on c.residence = p.origin; --ici le soucis c'est que y a des NULL a cname et customers parce que y a plus d'origine de pays


select 'Query 06' as '';
-- The customers who ordered only products originating from foreign countries 
-- Les clients n'ayant commandé que des produits provenant de pays étrangers
select c.cname, c.residence as customers, p.origin as products
from customers c right outer join products p
on c.residence <> p.origin; 


select 'Query 07' as '';
-- The difference between 'USA' residents' per-order average quantity and 'France' residents' (USA - France)
-- La différence entre quantité moyenne par commande des clients résidant aux 'USA' et celle des clients résidant en 'France' (USA - France)
select avg(quantity) - (select avg(quantity) from customers natural join orders where residence = "France") as diff_avg 
from customers natural join orders where residence = "USA" -- Ca marche mais je pense que cest pas opti du tout 

select 'Query 08' as '';
-- The products ordered throughout 2014, i.e. ordered each month of that year
-- Les produits commandés tout au long de 2014, i.e. commandés chaque mois de cette année


select 'Query 09' as '';
-- The customers who ordered all the products that cost less than $5
-- Les clients ayant commandé tous les produits de moins de $5


select 'Query 10' as '';
-- The customers who ordered the greatest number of common products. Display 3 columns: cname1, cname2, number of common products, with cname1 < cname2
-- Les clients ayant commandé le grand nombre de produits commums. Afficher 3 colonnes : cname1, cname2, nombre de produits communs, avec cname1 < cname2


select 'Query 11' as '';
-- The customers who ordered the largest number of products
-- Les clients ayant commandé le plus grand nombre de produits
select c.cname, c.cid as customers, o.cid, o.quantity as orders
from customers c left outer join orders o
on c.cid = o.cid, quantity>=5; -- le plus grand nombre de produit ? ==> on doit avoir la bonne reponse meme si le nombre de produits augmente donc on peut pas utiliser de valeurs fixes

select cid, cname, residence from customers natural join orders group by cid order by quantity; --> pas bon mais bonne base 

select 'Query 12' as '';
-- The products ordered by all the customers living in 'France'
-- Les produits commandés par tous les clients vivant en 'France'



select 'Query 13' as '';
-- The customers who live in the same country customers named 'Smith' live in (customers 'Smith' not shown in the result)
-- Les clients résidant dans les mêmes pays que les clients nommés 'Smith' (en excluant les Smith de la liste affichée)
select c1.cid, c1.cname, c1.residence from customers c1 join customers c2 on c1.residence = c2.residence 
where c1.residence = c2.residence and c2.cname = "Smith" and c1.cname <> "Smith";

select 'Query 14' as '';
-- The customers who ordered the largest total amount in 2014
-- Les clients ayant commandé pour le plus grand montant total sur 2014 


select 'Query 15' as '';
-- The products with the largest per-order average amount 
-- Les produits dont le montant moyen par commande est le plus élevé


select 'Query 16' as '';
-- The products ordered by the customers living in 'USA'
-- Les produits commandés par les clients résidant aux 'USA'
select distinct pid, pname, price, origin from products natural join customers natural join orders where residence = "USA";


select 'Query 17' as '';
-- The pairs of customers who ordered the same product en 2014, and that product. Display 3 columns: cname1, cname2, pname, with cname1 < cname2
-- Les paires de client ayant commandé le même produit en 2014, et ce produit. Afficher 3 colonnes : cname1, cname2, pname, avec cname1 < cname2


select 'Query 18' as '';
-- The products whose price is greater than all products from 'India'
-- Les produits plus chers que tous les produits d'origine 'India'
select pid, pname, price, origin from products where price > (select max(price) from products where origin = "India");


select 'Query 19' as '';
-- The products ordered by the smallest number of customers (products never ordered are excluded)
-- Les produits commandés par le plus petit nombre de clients (les produits jamais commandés sont exclus)



select 'Query 20' as '';
-- For all countries listed in tables products or customers, including unknown countries: the name of the country, the number of customers living in this country, the number of products originating from that country
-- Pour chaque pays listé dans les tables products ou customers, y compris les pays inconnus : le nom du pays, le nombre de clients résidant dans ce pays, le nombre de produits provenant de ce pays 
SELECT origin, COUNT(pname), COUNT(cname)
FROM products LEFT JOIN customers
ON products.origin = customers.residence
WHERE 1
GROUP BY products.origin; --quasi bon mais s'il y a un produit et deux clients qui viennent du même pays ca affiche 2 au produit

