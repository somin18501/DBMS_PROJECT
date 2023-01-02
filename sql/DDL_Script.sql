CREATE TABLE IF NOT EXISTS public."Customer"
(
    cust_id bigint NOT NULL,
    cust_name character varying(30) NOT NULL,
    cust_pass character varying(8) NOT NULL,
    dob date,
    pin_code integer,
    email character varying(255),
    phone_num bigint,
    CONSTRAINT "Customer_pkey" PRIMARY KEY (cust_id)
)
select * from "Customer"

CREATE TABLE IF NOT EXISTS Product
(
    pro_id bigint NOT NULL,
    pro_name character varying NOT NULL,
    price integer NOT NULL,
    dept_name character VARYING NOT NULL,
    brand_name character varying NOT NULL,
	plat_name character varying NOT NULL,
    disc_rate integer,
    ratings double precision NOT NULL,
    CONSTRAINT product_pkey PRIMARY KEY (pro_id)
)
select * from Product

CREATE TABLE IF NOT EXISTS Alerts
(
    a_id serial NOT NULL,
    pro_id bigint NOT NULL,
	cust_id bigint NOT NULL,
    price_drop integer NOT NULL,
    CONSTRAINT Alerts_pkey PRIMARY KEY (a_id),
	CONSTRAINT Alerts_cust_id_fkey FOREIGN KEY (cust_id)
        REFERENCES "Customer" (cust_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT Alerts_pro_id_fkey FOREIGN KEY (pro_id)
        REFERENCES Product (pro_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
select * from Alerts

CREATE OR REPLACE FUNCTION checkpricedrop()
  RETURNS trigger AS
$$
DECLARE ind record;
BEGIN
FOR ind in (select a_id, pro_id, price_drop from alerts where pro_id=new.pro_id)
loop
	if new.price <= ind.price_drop THEN
		delete from alerts where a_id = ind.a_id;
	end if;
end loop;
return new;
end;
$$
LANGUAGE 'plpgsql';

CREATE or replace TRIGGER trig
after update
ON product
FOR EACH ROW
EXECUTE PROCEDURE checkpricedrop();

select pro_id, pro_name, plat_name, price, price-price*disc_rate/100 as best_deal, ratings
from product
where price >= 5000
order by ratings desc;