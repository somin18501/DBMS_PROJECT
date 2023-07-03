set search_path to price_history;
set datestyle to 'iso,dmy'

-- %%%%%%%% DDL SCRIPT %%%%%%%
---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS price_history.price_alert
(
    a_id bigint NOT NULL,
    pro_id bigint NOT NULL,
    brand_id bigint NOT NULL,
    cust_id bigint NOT NULL,
    price_drop integer,
    CONSTRAINT price_alert_pkey PRIMARY KEY (a_id),
    CONSTRAINT price_alert_brand_id_fkey FOREIGN KEY (brand_id)
        REFERENCES price_history.brand (brand_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT price_alert_cust_id_fkey FOREIGN KEY (cust_id)
        REFERENCES price_history.customer (cust_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT price_alert_pro_id_fkey FOREIGN KEY (pro_id)
        REFERENCES price_history.product (pro_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT price_alert_price_drop_check CHECK (price_drop >= 0)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS price_history.price_alert
    OWNER to postgres;
	
---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS price_history.customer
(
    cust_id bigint NOT NULL,
    cust_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    cust_pass character varying(8) COLLATE pg_catalog."default" NOT NULL,
    dob date,
    pin_code integer,
    email character varying(255) COLLATE pg_catalog."default",
    phone_num bigint,
    CONSTRAINT customer_pkey PRIMARY KEY (cust_id),
    CONSTRAINT customer_phone_num_check CHECK (phone_num > 999999999 AND phone_num < '10000000000'::bigint),
    CONSTRAINT customer_dob_check2 CHECK (dob <= '2003-12-31'::date)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS price_history.customer
    OWNER to postgres;

---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS price_history.pro_hist
(
    cust_id bigint NOT NULL,
    pro_name character varying COLLATE pg_catalog."default" NOT NULL,
    brand_name character varying COLLATE pg_catalog."default" NOT NULL,
    last_date date,
    CONSTRAINT pro_hist_pkey PRIMARY KEY (cust_id, pro_name, brand_name),
    CONSTRAINT pro_hist_cust_id_fkey FOREIGN KEY (cust_id)
        REFERENCES price_history.customer (cust_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS price_history.pro_hist
    OWNER to postgres;

---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS price_history.platform
(
    plat_id bigint NOT NULL,
    plat_name character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT platform_pkey PRIMARY KEY (plat_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS price_history.platform
    OWNER to postgres;
	
---------------------------------------------------------------------------	
CREATE TABLE IF NOT EXISTS price_history.brand
(
    brand_id bigint NOT NULL,
    brand_name character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT brand_pkey PRIMARY KEY (brand_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS price_history.brand
    OWNER to postgres;
	
---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS price_history.department
(
    dept_id bigint NOT NULL,
    dept_name character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT department_pkey PRIMARY KEY (dept_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS price_history.department
    OWNER to postgres;
	
---------------------------------------------------------------------------	
CREATE TABLE IF NOT EXISTS price_history.product
(
    pro_id bigint NOT NULL,
    pro_name character varying COLLATE pg_catalog."default" NOT NULL,
    price integer NOT NULL,
    dept_id bigint,
    brand_id bigint,
    CONSTRAINT product_pkey PRIMARY KEY (pro_id),
    CONSTRAINT product_brand_id_fkey FOREIGN KEY (brand_id)
        REFERENCES price_history.brand (brand_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT product_dept_id_fkey FOREIGN KEY (dept_id)
        REFERENCES price_history.department (dept_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS price_history.product
    OWNER to postgres;

---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS price_history.available_on
(
    plat_id bigint NOT NULL,
    pro_id bigint NOT NULL,
    disc_rate integer,
    ratings double precision,
    curr_stock bigint,
    CONSTRAINT available_on_pkey PRIMARY KEY (plat_id, pro_id),
    CONSTRAINT available_on_plat_id_fkey FOREIGN KEY (plat_id)
        REFERENCES price_history.platform (plat_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT available_on_pro_id_fkey FOREIGN KEY (pro_id)
        REFERENCES price_history.product (pro_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT available_on_curr_stock_check CHECK (curr_stock >= 0),
    CONSTRAINT available_on_ratings_check CHECK (ratings >= 0::double precision),
    CONSTRAINT available_on_ratings_check1 CHECK (ratings <= 5::double precision)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS price_history.available_on
    OWNER to postgres;
	
---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS price_history.track
(
    pro_id bigint NOT NULL,
    plat_id bigint NOT NULL,
    curr_date date NOT NULL,
    price integer NOT NULL,
    CONSTRAINT track_pkey PRIMARY KEY (pro_id, plat_id, curr_date),
    CONSTRAINT track_plat_id_fkey FOREIGN KEY (plat_id)
        REFERENCES price_history.platform (plat_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT track_pro_id_fkey FOREIGN KEY (pro_id)
        REFERENCES price_history.product (pro_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS price_history.track
    OWNER to postgres;
	
---------------------------------------------------------------------------	
CREATE TABLE IF NOT EXISTS price_history.offer
(
    sr_id bigint NOT NULL,
    firm_name character varying COLLATE pg_catalog."default" NOT NULL,
    offer_type character varying COLLATE pg_catalog."default",
    disc_rate integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    CONSTRAINT offer_pkey PRIMARY KEY (sr_id),
    CONSTRAINT offer_check CHECK (start_date <= end_date)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS price_history.offer
    OWNER to postgres;
	
---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS price_history.applicable_on_p
(
    sr_id bigint NOT NULL,
    plat_id bigint NOT NULL,
    CONSTRAINT applicable_on_p_pkey PRIMARY KEY (sr_id, plat_id),
    CONSTRAINT applicable_on_p_plat_id_fkey FOREIGN KEY (plat_id)
        REFERENCES price_history.platform (plat_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT applicable_on_p_sr_id_fkey FOREIGN KEY (sr_id)
        REFERENCES price_history.offer (sr_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS price_history.applicable_on_p
    OWNER to postgres;
	
---------------------------------------------------------------------------	
CREATE TABLE IF NOT EXISTS price_history.applicable_on_d
(
    sr_id bigint NOT NULL,
    dept_id bigint NOT NULL,
    CONSTRAINT applicable_on_d_pkey PRIMARY KEY (sr_id, dept_id),
    CONSTRAINT applicable_on_d_dept_id_fkey FOREIGN KEY (dept_id)
        REFERENCES price_history.department (dept_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT applicable_on_d_sr_id_fkey FOREIGN KEY (sr_id)
        REFERENCES price_history.offer (sr_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS price_history.applicable_on_d
    OWNER to postgres;
	
---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS price_history.applicable_on_b
(
    sr_id bigint NOT NULL,
    brand_id bigint NOT NULL,
    CONSTRAINT applicable_on_b_pkey PRIMARY KEY (sr_id, brand_id),
    CONSTRAINT applicable_on_b_brand_id_fkey FOREIGN KEY (brand_id)
        REFERENCES price_history.brand (brand_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT applicable_on_b_sr_id_fkey FOREIGN KEY (sr_id)
        REFERENCES price_history.offer (sr_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS price_history.applicable_on_b
    OWNER to postgres;
	
---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS price_history.user_class
(
    u_id bigint NOT NULL,
    u_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    u_pass character varying(8) COLLATE pg_catalog."default" NOT NULL,
    u_class character varying(10) COLLATE pg_catalog."default" NOT NULL,
    last_status date NOT NULL,
    CONSTRAINT user_class_pkey PRIMARY KEY (u_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS price_history.user_class
    OWNER to postgres;
	
---------------------------------------------------------------------------	
CREATE TABLE IF NOT EXISTS price_history.user_contact
(
    u_id bigint NOT NULL,
    contact_no bigint NOT NULL,
    CONSTRAINT user_contact_u_id_fkey FOREIGN KEY (u_id)
        REFERENCES price_history.user_class (u_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS price_history.user_contact
    OWNER to postgres;
	
---------------------------------------------------------------------------	
CREATE TABLE IF NOT EXISTS price_history.user_access
(
    u_id bigint NOT NULL,
    access_rel character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT user_access_pkey PRIMARY KEY (u_id, access_rel),
    CONSTRAINT user_access_u_id_fkey FOREIGN KEY (u_id)
        REFERENCES price_history.user_class (u_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS price_history.user_access
    OWNER to postgres;
	
---------------------------------------------------------------------------


-- Inserting Table entries:
COPY brand FROM 'C:\Users\Public\Downloads\brand.csv' DELIMITER ',' CSV HEADER;
select * from brand;

COPY platform FROM 'C:\Users\Public\Downloads\platform.csv' DELIMITER ',' CSV HEADER;
select * from platform;

COPY department FROM 'C:\Users\Public\Downloads\department.csv' DELIMITER ',' CSV HEADER;
select * from department;

COPY customer FROM 'C:\Users\Public\Downloads\customer.csv' DELIMITER ',' CSV HEADER;
select * from customer;

COPY user_class FROM 'C:\Users\Public\Downloads\user_class.csv' DELIMITER ',' CSV HEADER;
select * from user_class;

COPY user_access FROM 'C:\Users\Public\Downloads\user_access.csv' DELIMITER ',' CSV HEADER;
select * from user_access;

COPY user_contact FROM 'C:\Users\Public\Downloads\user_contact.csv' DELIMITER ',' CSV HEADER;
select * from user_contact;

COPY offer FROM 'C:\Users\Public\Downloads\offer.csv' DELIMITER ',' CSV HEADER;
select * from offer;

COPY applicable_on_b FROM 'C:\Users\Public\Downloads\applicable_on_b.csv' DELIMITER ',' CSV HEADER;
select * from applicable_on_b;

COPY applicable_on_p FROM 'C:\Users\Public\Downloads\applicable_on_p.csv' DELIMITER ',' CSV HEADER;
select * from applicable_on_p;

COPY applicable_on_d FROM 'C:\Users\Public\Downloads\applicable_on_d.csv' DELIMITER ',' CSV HEADER;
select * from applicable_on_d;

COPY product FROM 'C:\Users\Public\Downloads\product.csv' DELIMITER ',' CSV HEADER;
select * from product;

COPY available_on FROM 'C:\Users\Public\Downloads\available_on.csv' DELIMITER ',' CSV HEADER;
select * from available_on;

COPY track FROM 'C:\Users\Public\Downloads\track.csv' DELIMITER ',' CSV HEADER;
select * from track;

COPY pro_hist FROM 'C:\Users\Public\Downloads\pro_hist.csv' DELIMITER ',' CSV HEADER;
select * from pro_hist;

COPY price_alert FROM 'C:\Users\Public\Downloads\price_alert.csv' DELIMITER ',' CSV HEADER;
select * from price_alert;


-- Trigger function to remove completed alerts
create or replace function checkpricedrop()
returns trigger
language 'plpgsql'
as $body$
DECLARE alert record;
BEGIN
FOR alert in (select A_id, pro_id, brand_id, price_drop from price_alert where pro_id=new.pro_id and brand_id=new.brand_id)
loop
	if new.price <= alert.price_drop THEN
		delete from price_alert where A_id = alert.A_id;
	end if;
end loop;
return new;
end;
$body$

create or replace trigger trig
before insert or UPDATE
on product
for each row
execute procedure checkpricedrop();

select * from price_alert;
insert into price_alert values(746319,9838428,3243,1,3000);
select * from product;
update product
set price = 2999
where pro_id = 9838428;
select * from product;
select * from price_alert;


-- function to get age of customer
create or replace function getage()
RETURNS TABLE(cust_id bigint,cust_name character varying,age interval,email character varying,phone_num bigint,pin_code integer)
LANGUAGE 'plpgsql'
AS $BODY$
     BEGIN
     	return query execute format('select cust_id, cust_name, age(dob), email, phone_num, pin_code from customer');
     END;
$BODY$;

select getage();


-- procedure to remove completed offers
CREATE OR REPLACE PROCEDURE removeoffers()
LANGUAGE 'plpgsql'
AS $BODY$
      DECLARE i record;
      BEGIN
           FOR i in (select sr_id, end_date from offer)
           loop
		   		if i.end_date < CURRENT_DATE then
					delete from offer
			   		where sr_id = i.sr_id;
				end if;
           end loop; 
       END;
$BODY$;
select * from offer;
insert into offer values(67423,'Gpay','Coupon',10,'2022-10-10','2022-11-05');
call removeoffers();

-- procedure to keep track of price history
CREATE OR REPLACE PROCEDURE keeptrack()
LANGUAGE 'plpgsql'
AS $BODY$
      DECLARE i record;
      BEGIN
	  	FOR i in (select pro_id, plat_id, best_deal from base_price)
		loop 
			insert into track values (i.pro_id, i.plat_id, CURRENT_DATE, i.best_deal);
		end loop;
	  END;
$BODY$;
select * from track;
select * from product;
select * from available_on;
select * from base_price;
insert into product values(9838428,'HJEOHE',7999,49,3243);
insert into available_on values(455,9838428,12,3.3,1000);
where pro_id=9838428
select * from product;
select * from available_on;
select * from base_price;
call keeptrack();
select * from track;


-- Simple Queries:

-- 1 Select all customers names and customer IDs whose name begin with the letter 'A'
select cust_id, cust_name
from customer
where cust_name like 'A%'

-- 2 get search history of customer whose id = 15
select * 
from pro_hist
where cust_id = 15

-- 3 Display all employee name whose name consist of exactly 6 characters
select u_name
from user_class
where u_name like '______'

-- 4 display the number of products in electronics department(dept_id = 72)
select count(pro_id)
from product
where dept_id = 72

-- 5 display count of product in different departments
select count(pro_id), department.dept_name
from product 
INNER JOIN department ON product.dept_id = department.dept_id
group by department.dept_name

-- 6 display ratings of given product on different platforms
select plat_id, ratings
from available_on
where pro_id = 1829523

-- 7 display all products sorted in higher to low ratings
select * 
from available_on
order by ratings desc

-- 8 display all offers between 15th of october and 15th of november
select *
from offer
where start_date<='2022-10-15' and end_date>='2022-11-15'

-- 9 display the average price drop expected by customer for every product    
select pro_id, avg(price_drop)
from price_alert
group by pro_id

-- 10 display the minimum price of all products in the track history
select pro_id, min(price)
from track
group by pro_id

-- 11 display all the product whose ratings are higher than average rating
select pro_id, ratings
from available_on 
where ratings > (select avg(ratings) from available_on)

-- 12 display all offers that are not on any platform
select *
from offer
where sr_id not in (select sr_id from applicable_on_p)

-- 13 display employee detail with most of the accesses
select *
from user_class
where u_id = (select u_id from user_access group by u_id order by count(access_rel) desc limit 1)

-- 14 display the detail of customer along with number of distinct product searched by them
select tmp.cust_id, tmp.cust_name, tmp.dob, tmp.email, tmp.phone_num, tmp.pin_code, count(tmp.pro_name) as No_pro_searched
from (select * from customer natural join pro_hist where pro_hist.cust_id = customer.cust_id) as tmp
group by tmp.cust_id, tmp.cust_name, tmp.dob, tmp.email, tmp.phone_num, tmp.pin_code

-- 15 display the minimum price for a product after applying offer applicable on its brand, department and of platform
select tmp.pro_id, tmp.pro_name, min(tmp.disc_of_brand) as offer_on_brand, min(tmp.disc_of_dept) as offer_on_dept, min(tmp.disc_of_plat) as offer_on_plat
from (select r1.pro_id, r1.pro_name, 
	  r1.brand_id, r2.sr_id as offer_on_brand, r1.best_deal-r1.best_deal*r2.disc_rate/100 as disc_of_brand,
	  r1.dept_id, r3.sr_id as offer_on_dept, r1.best_deal-r1.best_deal*r3.disc_rate/100 as disc_of_dept, 
	  r1.plat_id, r4.sr_id as offer_on_plat, r1.best_deal-r1.best_deal*r4.disc_rate/100 as disc_of_plat, r1.ratings
	  from base_price as r1, applicable_on_brand as r2, applicable_on_dept as r3, applicable_on_plat as r4
	  where r1.brand_id = r2.brand_id and r1.dept_id = r3.dept_id and r1.plat_id = r4.plat_id) as tmp
group by tmp.pro_id, tmp.pro_name

-- 16 display the detail of customer along with number of alerts set by them
select tmp.cust_id, tmp.cust_name, tmp.dob, tmp.email, tmp.phone_num, tmp.pin_code, count(tmp.a_id) as No_alert_set
from (select * from customer natural join price_alert where customer.cust_id=price_alert.cust_id ) as tmp
group by tmp.cust_id, tmp.cust_name, tmp.dob, tmp.email, tmp.phone_num, tmp.pin_code

-- 17 display all product details
select r1.pro_id, r1.pro_name, r3.dept_name, r2.brand_name, r4.plat_name, r1.best_deal as net_price, r1.ratings, r1.curr_stock
from base_price as r1, brand as r2, department as r3, platform as r4
where r1.dept_id = r3.dept_id and r1.brand_id = r2.brand_id and r1.plat_id = r4.plat_id

-- 18 display all the products and their availability in terms of current stock and on number of platforms it is available on
-- along with max and min discount provided by platforms having ratings more than or equal to 2.5 and arranged in decreasing order
select pro_id, count(plat_id) as available_over, avg(ratings) as avg_rating, 
max(disc_rate) as max_discount, min(disc_rate) as min_discount, sum(curr_stock) as online_market_stock  
from available_on
group by pro_id
having avg(ratings) >= 2.5
order by avg(ratings) desc

-- 19 display all the brands searched by the customer with most search history
select brand_id, brand_name 
from (select pro_hist.cust_id, brand.brand_id, brand.brand_name 
	  from pro_hist natural join brand 
	  where pro_hist.brand_name = brand.brand_name) as tmp
where tmp.cust_id = (select cust_id from pro_hist group by cust_id order by count(last_date) desc limit 1)

-- 20 display average duration and discount rate of each offer type 
select offer_type, avg(end_date-start_date), avg(disc_rate)
from offer
group by offer_type


-- Views Required-

CREATE OR REPLACE VIEW base_price as
SELECT available_on.pro_id, product.pro_name, product.dept_id, product.brand_id, available_on.plat_id, 
product.price-product.price*available_on.disc_rate/100 as best_deal, available_on.ratings, available_on.curr_stock
From product 
INNER JOIN available_on ON product.pro_id = available_on.pro_id
select *
from base_price


CREATE OR REPLACE VIEW applicable_on_plat as
SELECT applicable_on_p.plat_id, applicable_on_p.sr_id, offer.firm_name, offer.offer_type, offer.disc_rate
From offer
INNER JOIN applicable_on_p ON offer.sr_id = applicable_on_p.sr_id
select *
from applicable_on_plat


CREATE OR REPLACE VIEW applicable_on_brand as
SELECT applicable_on_b.brand_id, applicable_on_b.sr_id, offer.firm_name, offer.offer_type, offer.disc_rate
From offer
INNER JOIN applicable_on_b ON offer.sr_id = applicable_on_b.sr_id
select *
from applicable_on_brand


CREATE OR REPLACE VIEW applicable_on_dept as
SELECT applicable_on_d.dept_id, applicable_on_d.sr_id, offer.firm_name, offer.offer_type, offer.disc_rate
From offer
INNER JOIN applicable_on_d ON offer.sr_id = applicable_on_d.sr_id
select *
from applicable_on_dept


