PGDMP                         y           TechManiacs_DB    13.2    13.2 P    C           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            D           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            E           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            F           1262    47625    TechManiacs_DB    DATABASE     t   CREATE DATABASE "TechManiacs_DB" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United States.1252';
     DROP DATABASE "TechManiacs_DB";
                postgres    false                        3079    47626    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false            G           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    2            �            1255    47807    cart_amount()    FUNCTION     :  CREATE FUNCTION public.cart_amount() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	declare
		v numeric(15,2);
	begin
			 v = (select SUM(cart_product_price) from cart_contains where cart_id=new.cart_id)::numeric(15,2);
			 Update cart set cart_amount = v where cart_id=new.cart_id;
			 RETURN NEW;
    end;
	$$;
 $   DROP FUNCTION public.cart_amount();
       public          postgres    false            �            1255    47804    orders_amount()    FUNCTION     L  CREATE FUNCTION public.orders_amount() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	declare
		v numeric(15,2);
	begin
			 v = (select SUM(orders_product_price) from orders_contains where orders_id=new.orders_id)::numeric(15,2);
			 Update orders set orders_amount = v where orders_id=new.orders_id;
			 RETURN NEW;
    end;
	$$;
 &   DROP FUNCTION public.orders_amount();
       public          postgres    false            �            1255    47798    sum_cart_contains2()    FUNCTION     ;  CREATE FUNCTION public.sum_cart_contains2() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	declare
		v numeric(15,2);
	begin
			 v = (select product_price from  product where product.product_id=new.product_id)::numeric(15,2);
			 new.cart_product_price = v*new.cart_product_quantity;
			 RETURN NEW;
    end;
	$$;
 +   DROP FUNCTION public.sum_cart_contains2();
       public          postgres    false            �            1255    47801    sum_orders_contains2()    FUNCTION     A  CREATE FUNCTION public.sum_orders_contains2() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	declare
		v numeric(15,2);
	begin
			 v = (select product_price from  product where product.product_id=new.product_id)::numeric(15,2);
			 new.orders_product_price = v*new.orders_product_quantity;
			 RETURN NEW;
    end;
	$$;
 -   DROP FUNCTION public.sum_orders_contains2();
       public          postgres    false            �            1259    47691    cart    TABLE     �   CREATE TABLE public.cart (
    cart_id integer NOT NULL,
    users_id integer NOT NULL,
    cart_creation_date date NOT NULL,
    cart_amount numeric(15,2)
);
    DROP TABLE public.cart;
       public         heap    postgres    false            �            1259    47689    cart_cart_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cart_cart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.cart_cart_id_seq;
       public          postgres    false    205            H           0    0    cart_cart_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.cart_cart_id_seq OWNED BY public.cart.cart_id;
          public          postgres    false    204            �            1259    47721    cart_contains    TABLE     y  CREATE TABLE public.cart_contains (
    cart_id integer NOT NULL,
    product_id integer NOT NULL,
    cart_product_quantity integer NOT NULL,
    cart_product_price numeric(15,2),
    CONSTRAINT cart_contains_cart_product_price_check CHECK ((cart_product_price > (0)::numeric)),
    CONSTRAINT cart_contains_cart_product_quantity_check CHECK ((cart_product_quantity >= 0))
);
 !   DROP TABLE public.cart_contains;
       public         heap    postgres    false            �            1259    47702    category    TABLE     S   CREATE TABLE public.category (
    category_name character varying(30) NOT NULL
);
    DROP TABLE public.category;
       public         heap    postgres    false            �            1259    47765    orders    TABLE     �   CREATE TABLE public.orders (
    orders_id integer NOT NULL,
    users_id integer NOT NULL,
    shop_id integer NOT NULL,
    orders_creation_date date NOT NULL,
    orders_amount numeric(15,2)
);
    DROP TABLE public.orders;
       public         heap    postgres    false            �            1259    47781    orders_contains    TABLE     �  CREATE TABLE public.orders_contains (
    orders_id integer NOT NULL,
    product_id integer NOT NULL,
    orders_product_quantity integer NOT NULL,
    orders_product_price numeric(15,2),
    CONSTRAINT orders_contains_orders_product_price_check CHECK ((orders_product_price > (0)::numeric)),
    CONSTRAINT orders_contains_orders_product_quantity_check CHECK ((orders_product_quantity > 0))
);
 #   DROP TABLE public.orders_contains;
       public         heap    postgres    false            �            1259    47763    orders_orders_id_seq    SEQUENCE     �   CREATE SEQUENCE public.orders_orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.orders_orders_id_seq;
       public          postgres    false    214            I           0    0    orders_orders_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.orders_orders_id_seq OWNED BY public.orders.orders_id;
          public          postgres    false    213            �            1259    47709    product    TABLE        CREATE TABLE public.product (
    product_id integer NOT NULL,
    product_name character varying(60) NOT NULL,
    product_price numeric(15,2) NOT NULL,
    product_category_name character varying(30),
    CONSTRAINT product_product_price_check CHECK ((product_price > (0)::numeric))
);
    DROP TABLE public.product;
       public         heap    postgres    false            �            1259    47707    product_product_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.product_product_id_seq;
       public          postgres    false    208            J           0    0    product_product_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.product_product_id_seq OWNED BY public.product.product_id;
          public          postgres    false    207            �            1259    47740    shop    TABLE     4  CREATE TABLE public.shop (
    shop_id integer NOT NULL,
    shop_name character varying(30) NOT NULL,
    shop_phone_number character varying(10) NOT NULL,
    shop_address character varying(60) NOT NULL,
    CONSTRAINT shop_shop_phone_number_check CHECK (((shop_phone_number)::text ~ '^[0-9]*$'::text))
);
    DROP TABLE public.shop;
       public         heap    postgres    false            �            1259    47747 
   shop_sells    TABLE     �   CREATE TABLE public.shop_sells (
    shop_id integer NOT NULL,
    product_id integer NOT NULL,
    product_quantity integer NOT NULL,
    CONSTRAINT shop_sells_product_quantity_check CHECK ((product_quantity > 0))
);
    DROP TABLE public.shop_sells;
       public         heap    postgres    false            �            1259    47738    shop_shop_id_seq    SEQUENCE     �   CREATE SEQUENCE public.shop_shop_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.shop_shop_id_seq;
       public          postgres    false    211            K           0    0    shop_shop_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.shop_shop_id_seq OWNED BY public.shop.shop_id;
          public          postgres    false    210            �            1259    47665    users    TABLE     �  CREATE TABLE public.users (
    id integer NOT NULL,
    firstname character varying(60) NOT NULL,
    surname character varying(60) NOT NULL,
    dateofbirth date NOT NULL,
    email character varying(60) NOT NULL,
    password text NOT NULL,
    streetname character varying(60) NOT NULL,
    streetnumber numeric(4,0) NOT NULL,
    area character varying(60) NOT NULL,
    CONSTRAINT users_email_check CHECK (((email)::text ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'::text)),
    CONSTRAINT users_streetnumber_check CHECK ((streetnumber > (0)::numeric))
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    47663    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    202            L           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    201            �            1259    47678    users_phone    TABLE     �   CREATE TABLE public.users_phone (
    users_id integer NOT NULL,
    users_phone_number character varying(10) NOT NULL,
    CONSTRAINT users_phone_users_phone_number_check CHECK (((users_phone_number)::text ~ '^[0-9]*$'::text))
);
    DROP TABLE public.users_phone;
       public         heap    postgres    false            |           2604    47694    cart cart_id    DEFAULT     l   ALTER TABLE ONLY public.cart ALTER COLUMN cart_id SET DEFAULT nextval('public.cart_cart_id_seq'::regclass);
 ;   ALTER TABLE public.cart ALTER COLUMN cart_id DROP DEFAULT;
       public          postgres    false    204    205    205            �           2604    47768    orders orders_id    DEFAULT     t   ALTER TABLE ONLY public.orders ALTER COLUMN orders_id SET DEFAULT nextval('public.orders_orders_id_seq'::regclass);
 ?   ALTER TABLE public.orders ALTER COLUMN orders_id DROP DEFAULT;
       public          postgres    false    214    213    214            }           2604    47712    product product_id    DEFAULT     x   ALTER TABLE ONLY public.product ALTER COLUMN product_id SET DEFAULT nextval('public.product_product_id_seq'::regclass);
 A   ALTER TABLE public.product ALTER COLUMN product_id DROP DEFAULT;
       public          postgres    false    207    208    208            �           2604    47743    shop shop_id    DEFAULT     l   ALTER TABLE ONLY public.shop ALTER COLUMN shop_id SET DEFAULT nextval('public.shop_shop_id_seq'::regclass);
 ;   ALTER TABLE public.shop ALTER COLUMN shop_id DROP DEFAULT;
       public          postgres    false    210    211    211            x           2604    47668    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    202    201    202            6          0    47691    cart 
   TABLE DATA           R   COPY public.cart (cart_id, users_id, cart_creation_date, cart_amount) FROM stdin;
    public          postgres    false    205   hh       :          0    47721    cart_contains 
   TABLE DATA           g   COPY public.cart_contains (cart_id, product_id, cart_product_quantity, cart_product_price) FROM stdin;
    public          postgres    false    209   /�       7          0    47702    category 
   TABLE DATA           1   COPY public.category (category_name) FROM stdin;
    public          postgres    false    206   ��       ?          0    47765    orders 
   TABLE DATA           c   COPY public.orders (orders_id, users_id, shop_id, orders_creation_date, orders_amount) FROM stdin;
    public          postgres    false    214   *�       @          0    47781    orders_contains 
   TABLE DATA           o   COPY public.orders_contains (orders_id, product_id, orders_product_quantity, orders_product_price) FROM stdin;
    public          postgres    false    215   N�       9          0    47709    product 
   TABLE DATA           a   COPY public.product (product_id, product_name, product_price, product_category_name) FROM stdin;
    public          postgres    false    208   �       <          0    47740    shop 
   TABLE DATA           S   COPY public.shop (shop_id, shop_name, shop_phone_number, shop_address) FROM stdin;
    public          postgres    false    211   �       =          0    47747 
   shop_sells 
   TABLE DATA           K   COPY public.shop_sells (shop_id, product_id, product_quantity) FROM stdin;
    public          postgres    false    212   ��       3          0    47665    users 
   TABLE DATA           u   COPY public.users (id, firstname, surname, dateofbirth, email, password, streetname, streetnumber, area) FROM stdin;
    public          postgres    false    202   �       4          0    47678    users_phone 
   TABLE DATA           C   COPY public.users_phone (users_id, users_phone_number) FROM stdin;
    public          postgres    false    203   ��      M           0    0    cart_cart_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.cart_cart_id_seq', 1, false);
          public          postgres    false    204            N           0    0    orders_orders_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.orders_orders_id_seq', 1, false);
          public          postgres    false    213            O           0    0    product_product_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.product_product_id_seq', 12, true);
          public          postgres    false    207            P           0    0    shop_shop_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.shop_shop_id_seq', 3, true);
          public          postgres    false    210            Q           0    0    users_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.users_id_seq', 1001, true);
          public          postgres    false    201            �           2606    47727     cart_contains cart_contains_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.cart_contains
    ADD CONSTRAINT cart_contains_pkey PRIMARY KEY (cart_id, product_id);
 J   ALTER TABLE ONLY public.cart_contains DROP CONSTRAINT cart_contains_pkey;
       public            postgres    false    209    209            �           2606    47696    cart cart_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (cart_id);
 8   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_pkey;
       public            postgres    false    205            �           2606    47706    category category_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (category_name);
 @   ALTER TABLE ONLY public.category DROP CONSTRAINT category_pkey;
       public            postgres    false    206            �           2606    47787 $   orders_contains orders_contains_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public.orders_contains
    ADD CONSTRAINT orders_contains_pkey PRIMARY KEY (orders_id, product_id);
 N   ALTER TABLE ONLY public.orders_contains DROP CONSTRAINT orders_contains_pkey;
       public            postgres    false    215    215            �           2606    47770    orders orders_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (orders_id);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    214            �           2606    47715    product product_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);
 >   ALTER TABLE ONLY public.product DROP CONSTRAINT product_pkey;
       public            postgres    false    208            �           2606    47746    shop shop_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.shop
    ADD CONSTRAINT shop_pkey PRIMARY KEY (shop_id);
 8   ALTER TABLE ONLY public.shop DROP CONSTRAINT shop_pkey;
       public            postgres    false    211            �           2606    47752    shop_sells shop_sells_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.shop_sells
    ADD CONSTRAINT shop_sells_pkey PRIMARY KEY (shop_id, product_id);
 D   ALTER TABLE ONLY public.shop_sells DROP CONSTRAINT shop_sells_pkey;
       public            postgres    false    212    212            �           2606    47677    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public            postgres    false    202            �           2606    47683    users_phone users_phone_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.users_phone
    ADD CONSTRAINT users_phone_pkey PRIMARY KEY (users_id, users_phone_number);
 F   ALTER TABLE ONLY public.users_phone DROP CONSTRAINT users_phone_pkey;
       public            postgres    false    203    203            �           2606    47675    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    202            �           2620    47808     cart_contains cart_amount_insert    TRIGGER     {   CREATE TRIGGER cart_amount_insert AFTER INSERT ON public.cart_contains FOR EACH ROW EXECUTE FUNCTION public.cart_amount();
 9   DROP TRIGGER cart_amount_insert ON public.cart_contains;
       public          postgres    false    209    255            �           2620    47809     cart_contains cart_amount_update    TRIGGER     {   CREATE TRIGGER cart_amount_update AFTER UPDATE ON public.cart_contains FOR EACH ROW EXECUTE FUNCTION public.cart_amount();
 9   DROP TRIGGER cart_amount_update ON public.cart_contains;
       public          postgres    false    255    209            �           2620    47805 $   orders_contains orders_amount_insert    TRIGGER     �   CREATE TRIGGER orders_amount_insert AFTER INSERT ON public.orders_contains FOR EACH ROW EXECUTE FUNCTION public.orders_amount();
 =   DROP TRIGGER orders_amount_insert ON public.orders_contains;
       public          postgres    false    215    254            �           2620    47806 $   orders_contains orders_amount_update    TRIGGER     �   CREATE TRIGGER orders_amount_update AFTER UPDATE ON public.orders_contains FOR EACH ROW EXECUTE FUNCTION public.orders_amount();
 =   DROP TRIGGER orders_amount_update ON public.orders_contains;
       public          postgres    false    215    254            �           2620    47799 &   cart_contains sum_cart_contains_insert    TRIGGER     �   CREATE TRIGGER sum_cart_contains_insert BEFORE INSERT ON public.cart_contains FOR EACH ROW EXECUTE FUNCTION public.sum_cart_contains2();
 ?   DROP TRIGGER sum_cart_contains_insert ON public.cart_contains;
       public          postgres    false    209    252            �           2620    47800 &   cart_contains sum_cart_contains_update    TRIGGER     �   CREATE TRIGGER sum_cart_contains_update BEFORE UPDATE ON public.cart_contains FOR EACH ROW EXECUTE FUNCTION public.sum_cart_contains2();
 ?   DROP TRIGGER sum_cart_contains_update ON public.cart_contains;
       public          postgres    false    209    252            �           2620    47802 *   orders_contains sum_orders_contains_insert    TRIGGER     �   CREATE TRIGGER sum_orders_contains_insert BEFORE INSERT ON public.orders_contains FOR EACH ROW EXECUTE FUNCTION public.sum_orders_contains2();
 C   DROP TRIGGER sum_orders_contains_insert ON public.orders_contains;
       public          postgres    false    253    215            �           2620    47803 *   orders_contains sum_orders_contains_update    TRIGGER     �   CREATE TRIGGER sum_orders_contains_update BEFORE UPDATE ON public.orders_contains FOR EACH ROW EXECUTE FUNCTION public.sum_orders_contains2();
 C   DROP TRIGGER sum_orders_contains_update ON public.orders_contains;
       public          postgres    false    253    215            �           2606    47728 (   cart_contains cart_contains_cart_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart_contains
    ADD CONSTRAINT cart_contains_cart_id_fkey FOREIGN KEY (cart_id) REFERENCES public.cart(cart_id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.cart_contains DROP CONSTRAINT cart_contains_cart_id_fkey;
       public          postgres    false    205    2958    209            �           2606    47733 +   cart_contains cart_contains_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart_contains
    ADD CONSTRAINT cart_contains_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id) ON DELETE CASCADE;
 U   ALTER TABLE ONLY public.cart_contains DROP CONSTRAINT cart_contains_product_id_fkey;
       public          postgres    false    2962    208    209            �           2606    47697    cart cart_users_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_users_id_fkey FOREIGN KEY (users_id) REFERENCES public.users(id) ON DELETE CASCADE;
 A   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_users_id_fkey;
       public          postgres    false    205    202    2954            �           2606    47788 .   orders_contains orders_contains_orders_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders_contains
    ADD CONSTRAINT orders_contains_orders_id_fkey FOREIGN KEY (orders_id) REFERENCES public.orders(orders_id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.orders_contains DROP CONSTRAINT orders_contains_orders_id_fkey;
       public          postgres    false    215    214    2970            �           2606    47793 /   orders_contains orders_contains_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders_contains
    ADD CONSTRAINT orders_contains_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.orders_contains DROP CONSTRAINT orders_contains_product_id_fkey;
       public          postgres    false    215    208    2962            �           2606    47776    orders orders_shop_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES public.shop(shop_id) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_shop_id_fkey;
       public          postgres    false    214    2966    211            �           2606    47771    orders orders_users_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_users_id_fkey FOREIGN KEY (users_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_users_id_fkey;
       public          postgres    false    214    202    2954            �           2606    47716 *   product product_product_category_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_product_category_name_fkey FOREIGN KEY (product_category_name) REFERENCES public.category(category_name);
 T   ALTER TABLE ONLY public.product DROP CONSTRAINT product_product_category_name_fkey;
       public          postgres    false    208    206    2960            �           2606    47758 %   shop_sells shop_sells_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.shop_sells
    ADD CONSTRAINT shop_sells_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id) ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.shop_sells DROP CONSTRAINT shop_sells_product_id_fkey;
       public          postgres    false    208    212    2962            �           2606    47753 "   shop_sells shop_sells_shop_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.shop_sells
    ADD CONSTRAINT shop_sells_shop_id_fkey FOREIGN KEY (shop_id) REFERENCES public.shop(shop_id) ON DELETE CASCADE;
 L   ALTER TABLE ONLY public.shop_sells DROP CONSTRAINT shop_sells_shop_id_fkey;
       public          postgres    false    212    211    2966            �           2606    47684 %   users_phone users_phone_users_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.users_phone
    ADD CONSTRAINT users_phone_users_id_fkey FOREIGN KEY (users_id) REFERENCES public.users(id) ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.users_phone DROP CONSTRAINT users_phone_users_id_fkey;
       public          postgres    false    202    2954    203            6      x�m�]��
��={�	�#���7Q21Oӧ��1�>�ԧ>���W�_�O_��[�?�i��_YO�������U˿�������_����|���놿x������埶���=��5�ݞj��z?�]�������y�_d������5�痼?��U߁����V�	|U���������������/���Χ���+���I�G��q�0<������3ާ�F���O�F�[��{_�����_����ۈ��xm����+57a�� �}�e��I�x�^qo��S���F��-�5^*�#.��>�y����>��^K5<�y�L���ˀ�zI���l�����>_��x-���_�.��Q��s��-���n7VZ������M�'�+=��3^Ku��|��|}?}�(��� ����h��o�7���aW\�-�O��s��+^����Χ��k�_�{O0HK�������HGǥr �a�������SfZj�g�����}�<3fx������5-Uh�ٞ����n�'�	é�x��h-M2��qM�r�~��1l5홖��/�>����t7�H�T�<󤻕��ʳ�{W���Z�Y���p�՞�r�`]|�՟��B>u_���,�p�D^�Y���u��)s�p8��T˞e��~��\�Y;������[�Y���'S���c���Ι���>�y�h����"�T��\vz>���F�>���we�xp��5�������2lcƹAK�~l�"=-b籓S�/��uvN�]��n�;޻ݘ�-�З���wvxz�S �{��+�ߞ��D���s���J��ٱ�o5�v���+|,ʇF$!�;�����b����ʥ��������V'�����4I�nv�.G��og>���K �z������ēu��Uy�1m��v�����lQ`Jz^ՉL��~w��~Qb3�w�^pd*=�y�@�c��-�L�2���]YyA�q{a+��ͧQhJ,wwu��Y�g��J>q��FF!i]�[��9�հE�3��:�%��w�t��#�j��	!�nrUǺJKtU�$�zW��PX�݋p\Ϫϙ�	!�Z�d[��ʉZ��֋x?��>��?7���'n[l7SX_[��~�C�8,M��5��h�z�U�̊��6zE#�W,v��|���|����I�ƭ�-�W�sa�bA���c��!
��	~�"V���~��d�
;�O�@w�_�1E�;S�;د�X)n��o�W;����7c������ k?�`���u�Ry���W�k�`��U|8���������u����}s�����z��;���^9�A�5��7��!�b��YuM ���]�Ӏ��:]�;i�Y�LN�9[̖�u�	[ ��|���Ú�x4����@�BH�kb⥃�A@b�4F�-�X'7P� 8�&+Y�h źJ�2��(��h�H��u��A_���@�u�1$p�`ƺ��2���ƺf�{#���Q��ې�����&��X �����
|������i���J:��l��Oi�EVO��m1��S�@�;	8�&K�`�	��H"�v-M�Bs� <����� ��v>�NV e5q�F�w="��c`eݱ��;�⹶[��S=�dY7�	l�a��ɭDЯn.f�,,��>\@[\��5 ��N�FnWLX���q;p������z$�d�U��5Ysi�ZA��PC�H��5�z�dڬ't���a@�fM�<��c�8�B'�igM�ZB� ���M?�;��V2Ҷ�Rg�Vjm�bgL��~�.v���J��Ξ�Qĸv�s�q�_Ő"��M�I^�\4n.��R'�HKl:�xJ��.t�Vr���`�խ~j����Y+��sV�����yj F��b�o��C[½VF"����P9Ed
7g�Dϫ�����滲���5L��[�P>�VyY�E�mw�c\5-��vu��"�Ro��5hBN��/����vDȄ!Zpx�?�;�qQY�sg��v�Iܮ��ror����F�:qK�t����Sy=�ZER_�
6���ō��L��*<���ͱ��0��]�!>:l��;z��М;�=%�k�7I�w*ŐST̒���m8w��wN�ؙ�y�$��c�Y�]�9v�YĄ���G:��	�;cv��s琨��V�<��Fm�9x����_s������)�)�Bs�=��^s�#ｊ��sڽ�du�a�r�)�<.dB����9�U.�Ν���ޜ;S��w?�v�\Ԯ|5	39w��%vI,�\h�|6�u���5��s�%�*9�Ν���oaB�Δ.�vw�\t�������a	J�%�d4�=,��i"�4���8}(g5�� OEKs�4���:u�l%���ԙ��}(b���i�ElN�~ѯ���q�b�����/ٖ>�Թk~
�BZЩsS�l�����j�H:wn%����;7gI't�ܱ~���4��dϛ�H:x&|�ן���3E�"y���)�y�µ�x�c����Q�N�'B���N�I�w[Gs�<���LGs�<1En4��ѱ3��>��ؙ��T�i�����$���Z�u��~��s{�L�s�۪Ϭ7K�oax&��]�J�~�!�Q!b����fY(b�N�}���I��Mw�^г0)�]-*UE}�$U�u�S��U%��=z�4��#b�;�,���i�g�)s1[ԙf��p��k%b���`�jZ	��߃=CI{-�+D%n���}�ͼ�Mхv̿�����Lo�����t� ��3����|zh&t*o�p�)�-�HN�m�7h���W'{���rf�o,p���t���_tW��=�,qX��ݝ�w�z��>3hOyw��k��w�œI��i�NoL�uO|w��?y�Gf�^.����ޮ*���M��,ܚ:��{�u}x�X�QIx�H����׸����H;��	J}}�c�,��eYN [�-�Apg�tn� ����H~rn<1��OF%�a�!ۚ�^��`^4���lo�����9���V#o��^ҧ`�����"e�[�[qv�ii&	J�t��Sw�0��'[I��KeD�`_��Sf��ξ�)n��qWO�e��-q�wr�H��"`p��H�D*V�Gk�-,�|���o8KM���Ë��:��G���H�q��ݸzV�bxvc�DRM��3�~�?�#����0-���]r�jApgO��bJ��y�KF|��ǂ1B��w����ٍ��FT��ξEޒi��z��a'pg�\>����ξc�TMtpgO����;��=w(����Ξ�yׅ�!��oLI��o��irw�x'�ξ�o��w�C��%���u�%a]�g?�6b³�<�a�^�@���2D��@����;г����	��=�sk��=��4!��x!ա�eb6q'IH]#�n.���Q|mn|%L�g�>�lԣ�PGXD�qk�&��d�ԭ`�-�L�&��C���9S��9-k�\/��3��`���Ż��ʬ���/-)w�Z�����M�B8|���W���u(U#7���Ţ4/u�	��]bIX/G
������UH�yp���&f���~�i�&.�{v�_T��s=]�2]7\j2I�y�x�+�S*�\쒬U�q+�,ﰤp3�8�q��+��,L�EU�^����'�^��%tg�s�<G���&�^v(�U��9:7�;�bOYwGL�@ ϑYw���A�?}3�1�sd��yf <G?��¬�8���^��I�?92L��R��/2����D��
3_�,L�u���R.;�3��;���S�����R���[��xz!�sdIf�t� z�̻O7|X�9�>��Ka��O����9f`�g�ӋR�ř-`�1?�F�%�9�>�|��=G��M�	��#�O'Ix��XL�@ϱd�P�@ϱ�R���u�_|�:!�s$~�ʑ�9���˰��]q�0��#�;d��?/�▇�l��\R�7��#��WB�z`��R�;��#���aA����}/�
�0���c�=Gfݻ��@ϑ��A�a^�̄bed7��#���������s�kD���%c;G���26ۋ�    )q5n� ϱ%x��!/!�|4�g���)cl�J�*�l��L)����.j�17����W�&z��O7��3@�qX�/ 9��#��d-M���?�-�9���N�0!�s	X�C0Ƒ�=�z <�aF��na <G�{S��j����������X?�����q��$L��,�XEǚ��,��p�R��VVpMz�X2��=&����k����U�"�{��3��m;�X&��_�AV����;��Y����pMO�d��S�9q�Y%���xz���[�Zl¶��2*q�(l����j�!�"��7+���;*G���6`��ϡ����&(.��w0��Ӵf6ov`_��(��������Xf�}�ɒ	����h�P^9����ɒ鈕��эz�{g����Ep<��q�H����1�?����gk�=m���y�������H�R8��3�ϯ���s��e�=g)Xo�貀2��`�٩�K�|�Nʐ��	��)�.6|� P�`�&�sj�Z�{�A�K�wx/�Oa�	����!*�{�!�#����sĢQU�`�9$4a�x�=��_���Ou�����IQ�fzWP��Jhr*{_PʟM���A�{o�S3okФ���ț��?���ӻ�R�\�rM���)�N8�ChR
n�=�ȟ>/�9%��G�����,_[8M��s.W֩r��?�S�>��j��Bc�yy\Fa\����t�N�z3��^R��k!�si�`ϙ���D��=���*K1'�s�)$�4�S�>;�p>� �(;�9���!v�N��1��$�>A��d?I*���i���3ۉ�Ǹ��)��6�>�ny����Ϲ��[R&�'�s�o̚q0���\@�s�2�e��褅�2�}N)��4:��0c��b\�93���%&�s��h �3����X8���E�f�>��4i]�`��?o]e���ӤRo��ϙ�������
�'�����R 5U��v%�^6[a�%������g��7��S�Y��I�24��
详$/��U�_Y~\�#�.<�*��
&���O�i��W%�����Yr7�Ɠ��B/>���j�P���&-�+��i���N����ϮI���`U*�h�p�+[���ё��e�ڙ�_X�0�]�g�ڴ�z5�;�b}��-��@oG�`��*Q�<r��C�a���j_��ۀ5���~
�h������Wm���-�L��B��B�le���i]��u���އ�^j�si��X��:�!��~������ϕ�GS+)�su������ϕ	���*��YC���}��@oL�����	�o���ktu����m�Q�W�9b?נ1d;Y��5D�����K$�vd���	��k|<#��\���F?W"���ၟk�5���zD�?� g�ǚަ-�E������5�� ]����R��+5�_�O~
���m�Jz����#���V�%�kF'˛՗l����/Y4d��%��׃-$_���{�:=C���}뢁J�����%+(Ŗ��/�w�����˨�����+s���\�z�UgX��erN��j��eų������B.��lqH�B�&~F'�p��1���SI���˸�Hu��A�d�&�d�O9��M�K����x�~
��l�y�?W�N=�e�?W��4Ƽ ��?�_���38KJ�l�E�����i�[�ϕ�G�C"��\���h�� [d�w�?���!�"+@�����A߮� �s.��洀��pk�?�Ax�!��X�g�L�pm�=V0��L@Y�`�m\	����Hֆ��
y\�?��[�1�������$�6L\+̛H����9�>�1� Ve��j$�~�4b�|ƨ�L
���@�c�`�,��b/���2�`҂؛M�+O�1��*�Kv�;�PA��s�6�%��MK�k�5
��7ܬ5w���'�p�H�`Mk4�-��c��7��6X̢��W��z�1������oǚ]M�`��ϻ��bVX;|���1��<ݪL�-R��i���)Ę���<�O>-���@�Ϥ�֙*�j|Z�|�k�'|��}$�'|ZV�.m%1��e��=R(��i�Q�}Z���JK@�6$6�~l�O�����Ӽ�χa��=T#�`��T�c}����:��AuG}Z���J�yAXcp��@�6Y)]���Ӳ����>m�$���>mr;ibCЧ%��Dq.���ˑJi�4��$P���@��2�u|ڤ��妯�����	h� �I�,�-�Tg2��B�5���zޟd��iKl1�`���=uǖĜZ��o�OKt� Ч-Qwd&�>mQР�e~|R�i1��J�Z))6?B�x���3�D�$��)J��J�a~�Rh����OR2n���ݳ��dT��~�R�t��I+�yJF����iZ���ir�Re5��=-��4��M������G+�o�iɟ����.Xcs�hyl�=m32Q�n?ZJ�3x��>-k@�g>�0�$�>�0���.|�4 5*��4��
A|ZԀ�Ap~���³�=�P��u{�1}� �ӎ,����I[Rѕ���>�P/����U��)��:�T@�6o� /R���S�م0.���B���g����
��	�����O�f�|
�Lj@9�7^�N�T�ޞ��c����U��Rf��Ȥʭ�R�ژ��~t�4��c�:URݘ�;�iP�]y	�[�ɐʭ�%��ޕ��p����>u!�D�j2ch��n/���x;ͷ��X�~̀�r5پ�52�4�loH�/��T@��Il\a�����	}ё��
����m�hc���V��0ձ��y��Եuw?��]�jC���\@%@ޠ�ݙk���}�$�[˟n��](�!�}��t�`���D�����^8�A�;�w�i����ܐ7�sk>���s������{����|�lBjo���,|��f�=w*��$6�s9w�r��Ɍ@�yOo�$s	n���$|U�O�z��I��^���Ǌ!Ġ����~Z��pv�x��UL���z��Ϸ��5���[�HZ�A�����`Ͻ(s	�l��^[�<{���_�dX���_y�c��^T��|���G�1I��{nmB��=w&���6�s��KT[7�s���`�m���l����
�a�=��d���҄$� ����s��aA�#-�4OY� ��D��d�=w��c���_1��3=�?�6o?�3�ϩD��\O�v�ɞ�b�"����)�T�<l?�sK:�)���{&��\��	���P��g|f��e�=w��R�p�=��2^?[����0Q��pcm,�@�}D��C{6�s�i�EX�3��{���)��{8�z�?��JǏ;�� X"���'��٢�i)�?�L)�e)�)��I���sˏxt�gȗKvW�x��#���@�s�2i��"yn$/}�L���R�Kz��}OR���x�<Ԭ*=��M-Px|��.�Ϥ��\z�;�N�7�*��l=^�_iq��^�T描��U�z�-�Q%�F���ᇢ���3�*{�?��Z�lC������U���6�����u�Ă�a��y+�b�h�ZkV?e���:9[H�q)<~��.�σ7wT�2�oM��b�����#a�L`�ө��(}��'��~i��C�"��=` ,�<]�V2�{���U��� �љ'��P9`�#mHbB���A2��y?��\�y�`���OK��o��It�lz��G��e��*PI:���C�au��y��!���e��=O6!u�L��h���`�<�f��tj��I��ȑ�g��ђg�U�y��B��yf,�E;���L"��F�<	�U��y�$
Ă�ϓ ��߀�<KbV�v�y���f��$V���<���.?J[�5�p�y�V�O��Y��$��gI�*��y�I�;���*ЭV���.������1�M�N��hҡ	��D�`�|�4��!?Y\@����y2��t5��1�~Թ��l�L(� �   �瑣?E�>��E��;W�g�3��.��h(˃��lf	�P��<��S�+!��d���<g�Z�a~E����H/�c��y��x����3r�8���5/g�K�q��yiBj��q�G���8D�����#jp���Ϝ?�s��A?u^��?�����pz���������O      :   �  x�e�[n#�D�Ջ���^���qK%�U'`�`YN>��y�_��/˵�[��y���N��d׿�?�����������S���{��S�������_}��}>���\���y����������ϟ__����ϳ!�}G��O�;^�O��0ߟ�>���s��c7B�s�|}S�a]1_Q���l}�;��O�ϳ1������ߙ;y=\���t�ރ���F�g���?�����A��D�]A_A�}tm����|}�'h{�7��g�5�yL���7��3��
�7J�W=��3큙�|�x.�͠}�=ba�c#�8��0Lu8�GD�Q��h��w�߹���z�	;����/�sS�!�
30ՙϩη��%�B���g6��o�u+�;�ڜ�:��2�rLu�sSW"����ku��h�KڔbF�ƨ�u��Į�{���{��zp�������`���87Ȉ'y��8�cz����O5��:<���c��
9��'�^����-�kxO�5���%���/?�W�{S�{�s���SpoJs��>߻�e��9��f��|��}���q��yk���߯O��}�.�i����i��m"�mG���o�m�-� F�n��i��� ��s�����T�.��.��N�nO� /f~o��������wջ�e q����"e�X�D�r�<;k��[Ï)O�p:j���%H�pJf���Q;��Z�@m���]"�r���kP�5����ʸTƭ2��5h$��Tq;�!�cr ]8��)�ϒU�Y���wX������`� ���(��΢���e�YZ�`����X	/)�k���:��٬��6쟳�>;��Ζ��lj�lh�lj��(���l���B��4>'�I�,�����1;�t̠�c��1�����%|�e��ɗ�e9%|>�b�8�����qj�8+��,��5Ҿ������^���s	"�����U|���瓋ȍb�����鲇RD��$U�,�O���*.����O��K
�SRI��L|���)v��XM_r�
4S�i���"�v��K��㞖T|�e5e<�#���x��Ϡ�>#"��=�"��?��-�Ӷ b[	آ�m���E�B"��Dl�}�)��-�ض$b�аm�Ӷ�ae7��&�Q�c 7��.���&8ʎ4��R�%����H�;��>��i;��f��\�1��Ul6��N=������c�o>��v�� ���9El�\l7�����S���TO�&-�)��U="
��VY�)�W=6Q@�h�-XM[0�+��M����� ��%�%�iKdKvŖTq�"[����r�>��1"XVTq���M�	Ĳ�b=��b=m�z�d�M��PekI��RO[,��,�y�c���n���]��ʹ'鈌G�b-�p��&�eB�l c����FBЖ/�b_����Ůؗ�ؕl�R�L��$[.d�7�b��oV�N�傶\Ж+�rE[~$�aA�7����~���0�	a�����j��ʶ�D�n"c7�h���ܘ��XQ;��r�[�LƮp�]d�
�\��;/�\�;c��A2큚ڃ2��n=f8${Hg�!2���=��]�'�R.��7FɊ�Sd|íGx
�����J���[� �7G^"�BM�%:���CEkj/��m=�a[�{/��ެ��l�[d|íǂ5����fc�-:n���[��Эǐ�n���I�\薓n�Q��-�Ա��C�V,�ƱDƱDƱPS�b_�[!t+�q�n�&��M�&��-"�[��1�[�)����8�q�3�ͷC8l��0Ǒ�8�4�q�1�#�����Ø�è�0��	�W!�+L�M�J�B	W8��\�lβ:�p�S�!�+n����p&�I�"��l���# �
9B�`Y����)B��BN�l�T!'�q��5q$���Ų:n��Xa\Q4nDIYʸ��8J�\ �Q�dA\!�+q� ��-JV�-	9Z�� �'ǈ�c��U�0!��)n��m/c��C)W�Tֹ�)�r�be���R0W
��Eo��q
��E!疌���R�V�)��dչa���97���J���:�t������#Ny�U�8�R�Wy��Εb�Jr�4&�4*9�s�ɽq�	+�s�Q�il�S�XI'V�+�s�S��Tr:��.wN�r�
�R@WsrK���J9Ř����A)���i��CH�������LQr����x���3E��ӺQ�c ��J�jeIJ�u=",��,�Q�c	��:ű���:��N)��T�V*�JE])ƭlQr��N��lv�y��ǔ�y+Ž�Ô�#�u�@R\9"�au�b�*���&]�ô�\�B�EH-�ȥ����u�bq]d]%��6�%.����6e\ºJXW)�-2.e]%6��U�qm\%���t�a�\�ĺu�IB.�q�IB.����ti�q	�*����y)����u9k�r�q)�*���rf�r���D�u����i�,a]%V��a�c�*�����\!J�v}��\��d�\º*�%�8�J`W���vU
���.�����Sk�"�*a]%F�"�*a]u���Q�U�:nձ��j�q�G.qr���jT�����"da]���F�u�
Y�\5"�}zD�#:uP�e�^L�-���ֽ�E�Dƽ(�^b�^�^�ǽ��{3�Ю��ǽ��[iW+�j5s���[`Wo��}x��b�j�]}(�>�q�j5s���v���6긍:nc���Z�\m��x���Z�\mB��E���Cn�]���-��v���v\>��X�º:��C2r�@�f�^>u@�M��b����u���:y����je]�RW���N��-�����S�L;W���Ej��lܥ:V��%WO]4�4QW�踙��YWw���&�nA]�4evK:nusu�)���ZPW��������մs�����q��խv�YB�gQĳ��b:��t<�f��!]#�k��Q�5[��l�C!]#�k6�g�A�M!��\8����[=�y��5��#�zm�#���k�s�����iL^nG��ꑗ��'ut���G]#���5$]��8��!]#o���G-]�r�<�K�	4�#��G׈�k��`:�`a=�y�s�Z�&%9�$��ȫ���D�!����蚤�z��5�B.��CO׈�k�wOS,��D���PX�X�F,]���i!֣�'�X�F8�4� #�(�x�f��g��G�R�5�蚑�z�ySqPW�`���]E��������f2�Q      7   $   x���O��IU���K�
	��I,(�/������ �8S      ?      x�]�[��*�D����N�/��vT&6(��7N]�_������O~�SR���%{���_J��S�@�	c�)�����}F��>�=�=�zOp�s�ԟ��0x���w�{�H�R�_���q��\�?���X�������<7���ר�@N�����99?�W���Pyr�w�\p��Շ����_���7�2x_�c�2�������n��Y��ߐ�<�'����!<E�����w�^�$�>+'���5��ݫ��|��n�s/�!�PEN9����#]J�a������#�b�}"�/���]�$k���\���̧a����;��ִ0/��n�$q4�",G��Y�:����7�ّ.�=������k�}"�T��Z���O��x����[�?Տt˚<�B���q&��ݺ��r�/9�j|"l���}�\��C�Y�ƚ�[���?�5�x�3�;��TE�Ч���Jr������7\:�����[͞f�Z�n�|d��>k@�E+_���ϣ�k
�7���a4��R�w&����X�q�U�^nS�gr�O�ǜ�Ԅ���v.���x�;g?��ݞ�F�O�}��OW��о�xz�rJ����y��x֞ȖKGN덷-?��T¬Yy��d���"��X�������c�9���c]��v#�#v����~�f�X،L-�"���8J�*�~������g�zz<���e�r��xֹ`G�^?4�'���>^�!�=���b�c���!�j����8�O�p�~�dK��Y��!3o||�|�G�c��4�>�#�-��C�FyF�E[^|�gԣ֍O��;�K�@������f��N��-�a�01]�ק�ß���������!�1��.��B�<��Z�p�5Tè5[��<�o���a(�pɳ=���1ԟ��+Wړ-�	�x�A�ӟ��{���?i��L��P�u��%��PM"w%u��;���C=�����9;m0x췳�H�	�9RS��.�������r1cR���A�%)�ls��d�H�E��9y��O����H����Mò��y&�
��e��e!�\��0��L���^��S�L@H�-)5��Z^jK���]�����ꩴw�|q�K�˞A�������g�g�Ibb�f�j	J���C�%ThR1���L,�c�3��:B���2eUL!�ύgޠ�K�KG�`	�%ĳ���D�3쵰��TÚ������^b֯�`E�`�|�%�a|
�W���d�i��j���؏���<$�HrU��k4$Ggɲu�-�P[z��:�`���A�l����p'�hs��B�#=0�:�k��<ā��~�|ll��%		�-4hq��Y�ms�5�Q�Ы�PhnnS�����7�-?����KG��T s�'���C�'�@]�ȇzp%�s�Nu?b���&J�����P/0o�C�e	͠�u=�0 �{yT�G�$_���'<��(Y��SL�o�G9̟��֎��sKȺ�}F�H��Bӣ���������!�� :�JK������|�ڃr 5;�b8��<��Z����g�W���K����� �<:�I��}�3şJ�L���a� ���}H�N{yΤ1?q$�)�`,�/D�L,Y �_x D��z��� �V�`=�j����1M����[B@CCl�S�_�81*�,���F(��9�:7-TĜg�W�:�̬�bD��<#�X1�!/p�:�A/�v���)ɂ�yHd%��#<� -�y*1J>��'�C�Fqa���Cd�:.@w��N�6���tH[�zL��P˒x΅�.�rjz�rm!B�.�B�,}2�Ƒz*D���$�VzU�jy���NsI��}��;M�7Ɣf��,��>��yɅ�z��>�Ȇ4��x�f�rW�&߄�l�����+���*YS����+V��kDI���ߺҎ����5#4}��N$3�Y.�(��i���xf{�Ik�����
L2%I�a�׫�3�[�|�ȖY�I�7����$pM"I��k����L0�:���$�ej��=%�-`�u�O&�0\�(�-[&���{���
!�jRCr+]�Pw�d��u�fd�sb1�m��yH� �/�1#T��8W�e�:�bdͨ0C��MW�\0Eܺ��pԶ1����v�նq��U�D��(�d���t!D�c�����&L�$�_�A��{`л4�u�	�fh9�clIѽ�a�-)�?�:�ύA{��2S�XBt7�)"Y2t�Tz�H������q#$(����7�ۃ�[��G�`�J�YT��ڊ<��0���Z��3WjCR(d�-Y���3�ؖ�Q%�VDpt�m��5-8zA��*dcS�{>�ʳ���8��&�
ڃ�޵�sY.MV��������ӎfv�#RM� i�g��d���Р.)���$�cV�����Z�JU���<WB�oSE�D�mN_r-zh�����d�h��%�X
z����)B�����B��~�#X&���G��zh�����C��� r�9g�ڥ�@�2�Bw�Yf�g8�|Y�#�-\�	O��,��6� tstd
 �| �A�XK�#�A�&DO� Y��iy,�(v��J�NgȢ^]ە�hQ
A� �c��ٕ��7Y����w�������X�&DK>�S���Vn��_S:��d����Z�l�'_V�Y���������$����Y�&�栠u��c��d�Ǜ�ۃ�Od�߄�9��!����{���

��HrP�i�I�]�*'>�wY��lJ�)K��]�|�z�-Y�����WiE�T,a�/b�d�6(E�����bE�G��/%lЊc��򵂣99#�U�<eșR�Q	��J�E(V߼�pt�t�J��vW[��B��uM�STAi]�����h�G�K�d�*�D�LFW�1�eK�����W&����X0]�����Hh@���-0qa�)Ua�E+j2#�X�Э�	�J��ʓ�P[�y�		�Hw\�S]�U��Ze6��|����lt?��eK�n�Ͽ�W{b3ݓ����Vf�{����n z��#l�� i��'z�-����*�خ���i���кv*��i@U;W%[�A�]8���s[.Dr>��k2Y�e	�ĚXe5�Ś�X+���hS*�U�����q�;kʕA��-�Ѧ�Sۮ�m�;[��M���r�@��)ϳ��Af�]$��W�L�1�/�-0�z�,��M�m	?F����<ŉ�_n~��\PcǍ1�g�q*��D�#t���*s�#�nI֫��f�d����qKYƭ,���R�A��8���[o������O�P	��tY��V�n������(�c�������I"��^Ǳy%�S|�0=�|.���d�+-��]%}�z�[a�6��c��v��d��zO1N`�:�tbH�s���H���t��~ �-:9�U�~΄����0�lc�m��5�b���@,��%뉍�R��^c��@/C�mAc~"��Y�x��꤬�j}P��[V�C���d�h���8�ʯh=!�|Ro�I9��P�5ì������{:�	�,�/_O�иZ�Ճq��B@���pD�ny
�J��X�U�z�V�ЗU�On�-�lk^�+��:�H�UTJ�ZtILJڪ���T��oU4ۊo��Ǥv�{�1���#����|,h������5�a�U�ƴ�Tu�Up΄|jSZ�ζ�rܪUU"t��?���=��T]-mA�+��n����P�Jɂ�[=
�.nk�@Эj�T�0��U�<����M�|�(-��[Q�i�Ƃ�X�'K2H�d-4-��aMᩱlY(z��gj��lt���˒�^6qO�.���V�x,- �D��߱ �&���̭����5W�"k��֯匨n��֛=lgMw�ٗ#����M�:���6�s�.�F
���/��4�s�S��|�3�E���܄�W�xD~nQ�������ͪ�L��5�s��u\�~n��Vubƺ��bײM@7�By� �f    C>Y�0����_4%� �<�?�_8����Zq��Z t��M�� ��r��aݼ�˕2��n�oz�j��~A҉͹5 �^�J��n~ũ�^�|�Ŕ2&|9~����-�-��2��[U���Z t�ĆF��F�F�L��\еɪ�a�֗޲\�u���ڠ�y	���֡+	��nW-t�dbC�����QO���m^&�É��۬��ۀ���t�404�X�S{ �n��Cr��#��|^�!��[�����)�%��=q�I�Z�1��S��N�Й�L��#n�c��t&���`{z�
�"��x�B�\
_;�K6���}*�iwUG�6�����U�@�!Ǟb�pes�`;&)�X�;�3w�Ē�U0��[�Uֱ�v�e!�\ş��A�'_.�e�ɺ��c�CѺP��dt�?�9�E	��6[j�Wiy=������_n����$���6v�˷��va�����b��㿻P����r����������ſI�C�{���B@R���Ô���x���Ό�Tuh�qg�Y��������5넯!= t�~��r��m\J����� �^�8���@�=j�� 6!���n���1��;�KMG׵����R�����!U/��AA��8Z�ݯ���6�[�Q�3ȭnM�8���B�+N=�A��Y�<�G��䓴� �.��nB��&Z�=�R��~��� {�pJ��}�����X�N@�
�6�l��V@IE���J�vͩu6���U�0d��~�N�����gSba�sW�G���䎆�Qv�Ź�Ȥ6.�]�ca����i /[e��<-|���v��X��UWy n���2��iD|t`ȿ�g�?���j��I�)N�ƞ���Y�iZ���yHn��Aw��;�;�U_�=V�;�E��<�K.�jsB�HF��[��M���(�����u��8ǋ��_�� 4�M��B��(�4��4L�������U��݇ƪ�	����Yu�ݳ���v.vPt�C��7�A�$���B�Sk�;(�Ϥӡ�lA�}fE�(���>�ѯMv1	IFz=�1��h���e�1(�KF:k��A�}�.��W���e���;0����E�OnN�*��-��X�6k�#3��RH�ie�G-]��(�1K�#��� -����B�A�(����s�=��$�e�x<$�0��5��IFz-oGf�;K�v��$�l9�7W��V[���}Uv4������7\�"#��@c,_�|d�7T�r�/&��񇖵�Ll�a6��v�L�V[ç5��.�>�},���#3p������hV.T�\��q�5���9z	���Zӈ3!�]ٱWM��B%L*��.x��Uc�1�=2)�Кì�r�1�	��k�O�����V����lx)�Wm�)�3P��"*����*� hm�@���^ 4e⩺dx�	�Ԙ_oy�,0ڪnAHQn�h��:��b�h�|t��D@�c-�]�a����MjHmR�ѵ
�@��"X]K�[��m���� ښ����DD[S/�#3c�h�6]m4P4���**�� �L�@�֓���ZE[�UU��2P��+т�mWG�o�����F����%�e��)��P�VU� ��� q������u�Tu0��MӉ�R�q�t66���ѻ���lK��e���hê@o�8��jî��a,�lú���j�Zk�Gzl�a��A0�ܐ���r�M7�W5͙��h��ׇ� �Y�p`��M�ݻ`�h��w��-0�G�Tt�[z�h�~�0�d�a�~D��H�>>����Ñ�񐁢ͯv��� �&����m��pUD�9��qU��d�6T>  ����� �F�*	WD�PV�� ���ڐk�M[��;��h���C3���%�)�7mR�1�����mWv���(-�f�U|C��hU�m3�U�&ym��]7��fL���msȷ.�rc�}m~
\Oߘ��6I��&8x�ӅA��ܡN.;ֺ����!���񇞮���f�S���;�_ϓ����@�xl5����3��I���v8^˓'F{;�Nx�=b<��OVlMq"�#�.%���{�jD�0�.;�n"w�fϚq��F����ē����O�Pu�#;|uϺ�!S��p~ctl�s��Gw�o5d<�WNZ�,{a{�P������.Ҧ�����VZ<��ȹ6]%w����Q����e��6G��Z�D�)Eע�/�h9�����p���U���*/����-��_��F{mz���:0ګ��=���jbg��o?�E{�B��9(��T��ho��#��M5H�����i�f��HE���NMxc�-�Ĥ�ց�.�説�9(ڥ!�R�ӟ����D���h$풒�Z~��h�ѿqՋl���}WGϟ���viM�
�ʂ�=�����:��a1�mȮ��,���p�
nN�30�w����G�iUT���:Ϋ��]*;��U�1$dW����үn%�7�:�M��ԇ���4V�X��n�˞$7�jS	U ��ZX�,��ݴ�N:C: �-$�R(�l_��e1g;?*�����q����e1g;�gx���y��b�����k*H��8[�F��&j}5�s!/�X�lg'�~�
6��+�0��>��-R�d�>B�L9څ�]�\C���|,|9ڥa��.rC��Gϵ�s���DGJ,08�G����a�����8�,�`h�gm�C�l�*-ڣ��U�#Z@�KÎ���(- �絑.��հ�2��}F�C���SgX6�*4�FW��:ڥ�#�ʗOvD�Q�k?#i2(E�k�\K߻%�-���܅S�3�I���4��R.:��H��Ⱥycp;F��E���U���`�k��	����u�3|Wз�FV9	_J��`�6gqp�\�G,�HeǀҰ�h���6̱����{��-�Q���=;���`���dK���ev��ʎ79�'���ʎo���&��>���$��E-��n6���Y�,;-�-��~���@��oz�		�}������O(����Ek_$y>p�Qt�p5�ك��4�k��20�G�Hm����V�ل�=�_ǻ�/��ޣWqb4N �!ҫ�tAA�h��=j`b��=�˜�l� B�z�P�0���*z4m��[�`�!��~w��Ǘ�����Z�(��h����`&��ZW�E���R!�ҦG���Ѯꗈ(z4�%���~����HW%��W3-͡�fv&��oY�3Y�YD�R�4:k��<���Gg�h�jGg�.��V~ �G�F�ѭb����{�Z�����W)R��s�h�b�f����|~�ܞ���o߻#;0��+�/��˰\]���ô��T�0���Œ�06���)��� Ci}U�04�8S�k���M���1d ��뺼�y@��:vHM� D�E�"�Ei���=�J��E��`�		�FÕ�:�u6B֝�R	>@��%}0@�#j;ޒ���ci�����cw����e�Q��b��`��Q�E�s�`��E�4��}UH�x�%zh���(���驥Lcu�:��\y�W���·Lz��D�� �����B��(  ��ZA.7=��W� A��E��=�a�ۈ7n	�L]S4B�9$?>&{ik���8�BN����(G�+���鞤����vv.�ttW�x����&IY\��X�ݍs-��	�j�����3��U�R,/���@��-�|�$�<� ;�_��&��P���P&3޹�q��cP�v5��NV�f]U����D�],R�1Y� ?t�5Q;X�f8[�œ9���uj2_�����>����:���]���o.�t��@�)�M��,�ٹĢ؄�Em�X��?�EcU��O�̼�AR�8�S@�����xEw��t�k��.�H�`2���P�~`��g��)i�>+��W�=�>A�S��������Y��@�7NP��*�U�|�׃�g�u���=�Z!n	��gTI�b�	��R��Ҭb�g��)�Z@�lW} 
  b$�& z�*rO�������h�C�����͐� ��)�ȝ��ٴ6HvL@�l* qc=��1��	��������`���=��D��K�=�
���,�����κ�8;��I��;zJÎy�@����
�����/LP��Q4�3��Ӓ�(����iZ�)I=����!�E��6��U2A�S2�M��'(zJi�)!L�D����-=P�4W�E"w���i��j]�/�O���yP���t!�'(z�n������E�X�zMP��U�{��(z�;Bk�����$�����;H7�?�q��J��&z�-�E/���5�>=G(�ڗ|$��Cm�� zJ�+�=A�s��o�<��SZv�6qK�C�i�DP������]=���i�����!bW/��B�oC����ݕy��Enf�W��ej��+3��k}��W�D�hq���̦�/�����"M��%Z��4	
d��䯰DJ�-?8��̫�,v���S,WO�0�r����:������������      @   �  x�e�]�۸����L��{��_Ǖ�sb���Q�8M��!{�+_���w��+^^u_������|����뫾��~�����j^�����j_��f~����">Wv^����|j�2{^���%���~�s���\�����S���ѷB{�t}�S��U��󿿼T��j�s}���wݨj�w��R����|W}}�S�U����~/������?���;^���s���_�ϥ]UN�:���䪣�U__����{C+#�?}]��8��|���Ҩ����k��st�3���ￓuU��*�]�w9\u�����T��{]�tU]NK����|V]uU����t�k���wՏk�
��U�ѽn�aU��\!-J|K�{s{��f1�[��1��1��s��*��y��o!��@�}+��v�3T���ո��^�{���zE��|����oa�t��ոK+dY�8T6���,G$/l��曍���}>� ~���\"v����	Z%vޒ����Ϛ��|��ܪ��$;ˏ@;��n����!hf<ci�������y�:7cy�5�X�f˷����\4jnl>��>���I��EKǼ�Os���S�\~�[���x��g$�|�zڽE�#�bxbɋ,�#H�PK�����d�"�d	X=&-�f ��P�x-Y�V���X�V�K����RTP%SPb�V,b��)(vU��#h�&����B�������:~tWݲ�z���)h��z�ۈ��I�kCk#*Q���#>kYC{d k<�e/{�m�
��ֶyv�%�]��O������Q
�]7��.M��	�����k�����G{�#*��,?���%�g��!?K3�4n�b7��\Zy�a��	p���M��mh	����؍������I���e��Cp��{ѓ�]zdw��������=�Q�pBOB$-#��!ك��C���S��=YȞ��(�g!ɏ=�'!�q��]�'�'�K��%��%��<�"%_s�(R����� J��-{ږMm��C��I{��I�-Bn�co��6�̮�F]��(y���	����Oɣhď}�0+;sPKw�v�������&׿�U�JW�+]��J��n����n� 7vpS���Q�� *۱ce	A���"�Yn���:�U�a��8��8�8K#��mu|���|��c���Ȏ�fR�)��:���0Vq��L=��ُå���z~CT�]u8��T�)p6�p6��qܔ����T©B����T}P�c�}u(�Z�}u��d%G�9�9nh�Dm�XG�#G�#����D�U��]=�ِ�X�Ql�q󫯝����H9J���aX!�H�ِ�ِ�E�B��i�͆²B`V(͊Q)�J��V�HyX�C~#J�7��gَC�V�
yŎc���%;���q,�q��xEƠ�: �Y�V�
��p���gf\!�+�0��mun��w>��r�r}N�\y>�J��q����)W�8���)���J�\i"�4��Tȕ7����8�q:k8���)�+�r�������P*�J�\��+o��(0X��T�P��g��3؏3y��2Δ�:S�t��q
�J�\�lǙ�U��*(>2ʛr}��X�Y�Tg��8K��,�q�8re��[tܢ�7�q
���$髳U�J���)�����Gt<��9�c�\)�+s�s=O���N�\ɘ+s���8�r岌��8��8r%��N�'T�`X�`X����1W�O{�9N���q��uD�uDƥ���qRq1�è���\�z�{�2f�e̪�č�č�do\�=u��uS���U\���̩�ݸ�w���rQq)�*7.����q�0�
�׍�S��
�WpG]�".E\"�R�U�u݈���d׍���f\�!$��J��J��J��"�*aե���:�*VqWqf��ݸ�iu���l�u#�G�-��Z`u�9U�W�渚ݸ���j�k؎K W	�ᶺF��F6���\_+�a\]#B�׊��7ǵ��e\]�~\¹J9W�*Y9W-������; Z��	w@�|���2Q�U�'�!Zn]}X�}���Ýu��-��t���>�Z�t}'�M����̨�%���[�W-��Vߨ�[���["X-�vq�v����[@W;Yr;Yr�j�\-����>w�r}�Pk�C�rK"����L�[ W'�@Z W'�����jMf�2�V���j�\-��%����X�-��!�c��j�\]b��OP����kVK�Z-*nv������-��Gvȭ����V�:�P��1c��Ղ��1WKv�Wd�bɽ«[�[�"��c��W���޺%��`!C�n�*d��t5ؑ|��`%�a%�aG�s��FH�>@�s���Q�5�z�8��O����Z�q
ds���F8����z4�5.�z$�5��Y���Z����Y���s��&d�<![�	��<�Ꚑf��G�\d�#�kn����d!����8פ�'i�<�:�$?�d����4�7�s���H�k4�5%��(�IsM��G@�H�k�yt����5-2V�5������z�e<l�#i��4�H�kn��������:�H(sF��Y��Y�ճ"����Y>s�e^=��s�r[=+	jH[=�������@rԠS�w��1X� ;^�\+�k5εG�x�Ʃ��~�a�$���=�\����
�Z�s����8�j�kt�ĹV�\+q�u��
�Zg���s*s]��E��"�un�7x�Av�����YA]+i��4�
�ڐ�zum��WP�
�ZA]��=^A]+q�M�
�Za][�ǫ�kK�x��x��xo�����x%ϵEB^F]+i��4�*��V!���
��!��F]�%ϵ��z��Ե�R�W��vD���!f�+J^fֻ���r�kWt��U+�Z�\�d������\�s-(]��Zp[���z!2�ƹpS�oEʅ�2�P.�P.�������y.�� �$^�sA(�U�\�@$�y��}5��54��\�@�s�9�C�����!�C[2$�%]�1B�u
� #X�ԅ�`&�u!]H&�H~�	�BJcE]HQ2u�F]�9҅b%C^EDqg!]�8�J��q.h��N"�N�!��d邐.42�B�0����J6d�1�d]>{����ߔ����tae�%]Xyo�²!C]�It|��tAH�Yh���C�D� ����������ϟ����A      9   �   x�m�Mo�0@�ί�iG�-�m@��j�t��]�V��JR����jhH>X~�2�6���}bnZ�s�^�8�p��ٶ�u�]���s�D �k����f{
�5~o1Fr�Ƞ�+̗���:$���P:��t�wl
�R��}8x�Zk��q�v��1�)_����G:�$��o�Π6�nm�1H���.�yV�9�Һ����2�j��xؔ��+J��{��Fuڻ>�њx���/�ۄ1�En�      <   m   x�U�1
�0F�z�9����S���Ŗ�	D�L��bg��'�Kk^b�����s*� ��!�4mu��0^��	�J�wV���c��z"X���9ߧ�=�?�|�$[      =   �   x�%�K ��0}��]z�s4�F��D�F��
y�������p��E���ԘAT����KUlaZSr�/�{:�t���kd|P�vPBA�!��P�T]h��<��h��u8��o�ӣR2����� �      3      x�l�Io+K�&�6�
-�սE���I����5���;}�| �\U4z�hzQ��]Gu6Й�4�@"QY��/�D�����;�{_ �/Ͻ�hnv��/ʶJʚ�1o�	ob^�:)[�8��m�|Y����}�w*����w�n5y|H�]j>�N�~����}8�|:����,��F7M�-�����+���IRf���I�ö>R�2�I�e���~v�MQ�V�D���w���J���LvU6q�M�,d�eXl�3^D�8���U��y�?��d�ߔ�����)�l�D,��,��vSn?e����u�Ƽ��m��l��5v\ǫ�
hc8��㒦�AR��6�:��7*��z:���DQ'EԔsL�dK|b�����$aQ�G>?l*��a��A�A�X��)l�}��MVa��8U�o��׋�g6)+/,�b�6�7G�;9[n����N�7���'�.���,��녷����(^O��3��aӸ��>�*	�#�-��	L[�sCWd+t����@�7j�W^`��m�������~�[6�x�]�4]���h��=n��fWm�K"v�,�ii�����X,��tۼ�-{�y�4�ظ-ڤ�����;�w�`w�UǦU�ck$��o���@�,7����w/�i�-���e�mjܔN�}�oxU)#6�/��}����~SU �.���n°������ʢc���l�=�\��|]�a�U\��`q܉EK�^Otܠ��#9�Ұ+��7����{;�q�=�#k���#H�mQ��0(ٲK��)�?X�����.̤���7�����y�O����
�\��#��YXEm��`�$a��:��� �u�hS��{��#s	��������G��<_�D2!݄�M�Y���ʯ��ƏŚ���md����Yea��e(�����?T��:�����:V�(�\�7.��X�+ɦ���v������&�x���i&�H��j���u!n� ��AO�]�x�X��ͯ�t�;�N�4*D�����w/y���C���B�>X�i��z��;�E�7��UĮ�R����S!�x���]%~�u!,�݊=T8ƬߨFҝ5����i6��ҏ�j��t�BZ��8�(�J辅!5�s�E�ͫ��^�-�5��N�~�G����vs~�B��%y��GP�˘~%k� �88���E*/����"J���<���y�fO���K83l�d����?����<��?gG���l�A<��t�FR�3�^��vI�R���#�}{H3(�[��0ll0�چ􆪲7.��*�AeB�������m�e�6	�G,�U���=gm�ϙ��'^�����?G��p�9��$(�l���#+��������]�ay����E�А��iCu6�ò�6�����g\9��g^y��a#���M��n�s������e��H���f��XX?�e@JςQ�x��#p���)8TiEbߎFFw	y R���ث2�뻳�p�T�5�EX�_�(C� vt�~X���'��3��d��럔.�{�Vr��x{�&[#e�a�����ʏ�ik�}�!�St�:��������=@��?�?�Aڸ�$���~ȼ���$���I�J�,���W!���y���z��u�ֱk���3�|��� �ӑ��M�[Q�P�K�($*c�wy���ou[}[���#��|���Y�cR�Po��]O������3ʨz��n�q␰��}%��V��2*+ mD'�x@�X��8���f�/H����}{����OjӀ�{h���@R [
�������^ə�b���Iab�'l����AW�_BS�`:�pˏ��5?�T�H�юa��)"%o���-ԱW�A(V�MO���M_u�T��ںf���y�����.v����b�k� m]RR�O����6?!Ófip�!��#9�t|yQ@�/�(
*	�a������|^7ߡ@�ur|ʦ|�T�(Tvؚn��q����OC	7�l�: ʇ[7m���
�X�w>{Ԍ�5�Jrfh�F�3/C^|�o�e��G�	�Ca�2zP:@C��;�;؇.8��P�,��ե�f�5[�-8H�HA�ʶ �;Ҁ�q
��A)A�E�;�{����6q"W����*6VoaR��:���EÁ"��H��e�Å�_6�'P'��6�dX�uM�;̔����A�S}io�w3�0�&�y�!�`W�W)�y�e{��U�u,+$MQ�zS6�Jjk�m���=;�B�p�d>�`��{̒�cB�љ
�z���XB e��[�4������`82��vt��I��v	}/��1>�G�q��Aр��{����?�S������eۦL���ХG@'S�
�q��
�nӷC��{���QYF�t���F��o�O��r�	���ρMZ�?���j�UmV7�P>re��*�>�d�w��vx��#\�U��i6ˢ-|��H�#� d��)`�宀]��� �"�b�Q�ĭ��.�p�z�R(�%Y�$��z��ָ�<��t�48���XB���tAΤ���)�k?������6&b>�w{����# 8�@p蠧x���Q�#��D�v����0v&O���=6<#@ҁ�r����⤀HҮ� �[M	�۴$_I����g/���鸙�ӿ��4i�V-��mq|�	�l�x"���Ki��V���e܊U��j�o��������,�
 �����q�W/��!���'*�[��F�p�x��|AZ5(aftw'���6�эlFWA��>�ߪI���I�]vkxP�.��2�O.����ꝝ�%,&SCe��Vm�1j�#8'] Ʈ�9�z쫓�幟�N	�Q����������qp�"�d��+\y�G��Bt��%�uh�2� ���`M��� m������]ޜ�-{,�0�M`>②�Y��A��.ПL�N�+����7����gÌv�A�_P��o�	�Ց��R�!����zQ�Al�	� ϫw�g/�k����t�o�\B�-8��Yɒ�@�Y��{�o
�T%v7qٔ^�^�Ӣ��׳��>�%�1ńf�$$��̈́�l�'x;�3:��æ��,�!�6\˗Uw=}�t-tBӋ��`؋(�YP�!��9�������)��De���ͫr�� ���P�v�wc9��Ё�O$7b�G%�1bIބd-Ӽz6>N�=�-�i�]��8�
�#,=����������R�z=Q�~v؋���zĲY�Ñc&����ns(<��4�+�{�%d˒�(J����
o#�>��/^�eS�����zd<�&�˪yh����p~¦��	'��:�N���9t-���C"6�����h���^�B�G����rX�vӟm�r�-��t��$��`d��}	�g����Í�����F��򃏍���������9��kx��O�hv~�j��t�';�����y����J!*m��gx@�ݍ�Y���v:��NZUM�Y���v�2���<2�ėJ,SĻ�$M��<!hT�$,�)��O�5�N+�n��*bE�B�K��Q���	� <4�vWp��?;�n�b���H�{�?-�#������#{)�_"o���m��J���듏[~�2�8S~��PP���ȴ�=�(�i�����* �Һq\��-�����ֻ�'�	�h��;�h8�7 ��o�&�LU% ��;���&�eY����W�	LR���]{���Z��:B$��=Ɏ���?U<>�F�]6o=^����v�J��s;|1\Cq�鶙�ƻ>�Z�N?�g���o��)�#K�M��kRI/�i��;���eG�Y/3�=�^�|ݑ����%5�avd�d�/��i$��̫%M�\���I=0�c�m�C(�Pl�^�d�pa�'�ޓK�~I$~OT�.T*o��N|I�n���B�g!܀�5�wB�^h�#Kg�4�4��t�٠���H�:ryp�����w�%�W�f�tw�$.��Y�-N��=X�n���*�Z��Z�$?߫�=a��n��    [p�Xsŏ��7��!�X��]��<x2E}@B:���Z�T��˲XUm"E�N]��6�`�ີ��F�ˢ��c����?YY��c�	4A&.�⊋�Þ�j?c�h?=[?��ֆ�&�:�Ч��P��g`,���8	��zۦ��Iտ���i��ڭzGN��uL�T���pY��~[�Ѐ	��O���d|�g��?�\q���k��ߍ<���U�4�K'`t�
G��݇�����$*J�P�������Xz��2%~ڑ�4(���r+G�B�k��0B>Ŧy%��tx�U���޸���9���@uU#�]�����*�_2��Y ׺�Z�W���P��F2��[P��Ŧb6����Rx
נ��ou���IMY���������HAS��	]{�F���/�/�/�~|!3,�nӤ�;~��ʫ�Zl+�I�V�q�/H*w7�<H�����n6��g����,sq�v���*E!�,=AR�����C����XSXW����� ��#��CQ�7d���IpRa��������t��+���B�� ��S���qYG6C6��u�	�i�<�jஓ<B����}V�F��t`9/�n�yٶ0#���g�N��4(,KIE���bc�e��/ޝ
�XN^�%��Z|=Y)�s2#E
Q(Ҕ�)ԕ�T��V{g���c:�%uL�;�� �{a����|�)���_;���N��cU������g-1mt �c/�	a-����$"��,)CZ��l[E���T��E3�,���5g��9*�b��&���51(�%�S��>��i��&�����}`��6�tl��@�9�ܰ^��/H8�'i�ڍ�҇����\1w�]���'��I����^l�#GgW	E
�A�R� )B,��$5u�\�S𾾼]�Sf��VG�JJ��7�*�����*�q��ވ��{�������۰���|j�O1[nx�d~�M
Q�����yI~���ج��j���Ƨ�ּ|�x�|f M�}���e��-p<tgX��*��)�w��j��*���qs��>f�8�c2t�j8�4ع�$�� �tA��Zb*B��H�8�x
_1!f��%��6��X~�j�a�dglu��3�E�;<��˰��_�#:qN��Z�3]�C֘I��qW�/n�3���lR
����A��m���~���=�
��x\�Q4Dn�� ��?��� ��f�d��t���ٴ��3��������W�cu���$�`+m����'�Z}QVF��|0��g���(�؉�� ;�vذ�k?�W�a HjM-W��/�V�z�7ϣ��zOB�IN�
����;i+�.��g_B�@�����~�E^�V̽�ʦ�6�P���i&.���˲��OtgYY��k��I��JD�'e^7]�N)����I$�uk i^Fs���w��]��7��5�T�3 S�`]�,5�J܍��ce��I��u��}L@�k�0��4���QfH�:��/Х��%yQV��ꁏP7�F�ԝ�bG���f��-����)�^ӨB����?cUK&K
cT�1}[��b�́�~��X�Fܦ�g����D�=�'i�"��*��a����t�@���#K(/ҭp4��(j��x��ߐ�����}�aI��� �>�	X���ga�����>e"�]"O�Խ%���yXo��kC};�U�VSŮ.yut�@�(pޞd�B`:��M���������>���%�Q�TZl̻��k��2���3.�1"�өӞ�)�ּl�X߈h�Vu�rG���\��1J�]�p9۠�`��X.i��S����Gӏ?�T}S����T^h���
˧5�k����k�-=N�����꼞�i�,�L@m�i�O��-Y�L$NF�b�SZSB
(���"~C}ab�E�@��T��
���-��sgkHONf��?� �(̒5�	PrRz��>�͒�[�1-�����k����/`H���m��1���	���:���^AU7&{�T���:,�D�p	g��d�t��K��у����tqݦ.)L��8:���MK�{��yh��m�$�0�鉚�F�rlY�7ٽN*5�����E�k�N�n��X܆�� �5o���u�+P���M>P5�m���4�;>tt����[8;S�?�� �m�O�dmGDa�H{<G[X�z�j��6���J�����e�ؐ�9���#��L���jB��=�|AҸ���3zo���c���KǦk�����?�)�p�&��M�zI��4!�
�WȚ�z�G�	w\������JY�e8����RT1���D&�gU�m,RlM$H�O"(���Ɇߞ^����jb1��gd��Ź�T���m�c���^��璦P� fR���� 4^�ƻ��D��4L5[Ǐq� �%6�<�e�A_��!�%M�KAZ�⛸�F�a\<9�dq�u��FŁ&�g<ߔt��������;�������͓��BRv�J:�U6�d�3@,�?AVǂt�$�:	����c�i�Y׹��,�(����yW��p����J\�I	F;�P��s��[�h�M�6W!�C�"J������V���K�`M�5��7`���?a-r�w8f\���� ��k�c-qW U�P� ��y�,�}��O7��$�O��v
�������]��d��M[�IAX;����'�8��2�&�C�!a�#
�ŧ���u�|�n&���������y���.�{��*e��-^&Ÿ*�HDVu�b����H�h�{0<�@%�4n����	��0�R��?�f�^C�j*�� �T���(�p�\r�6\Ҵ\8��^��M��J�Zū�<r�v<�ӎ��	|8J����$�p��׫�O��X���&D� ��!LER����ُ��bm'S�d`M�$D��A��C�q��ˉ�ˆ�e�I�G"�{IU^�o��l\��@���`KC5�(��݅���$4<
�N�v�m2���S����a�o��B�cG�6��
a�V��F?]v�U|�j��Ww<����F'�J��T���Q����j���B�l�{��U�n}��)�q����Rs�|�e��8��X�?� �$L&�)��ESM-HZM�<�t�'��,^z��Aʀv�TQ5ŏ?bAB�`�k`p܌w}*$2u���5}�s��>�=�zg�f��ʪ������������1��&�(36�ʏ��?3�
+<I��C=�Nr6���oT�C!P����y�ƍ`QED:f(�!H���<AҶ����i���~�H���� j��*�O$k��p�[͐�z��s+�����2?�2��I	S�J1(���]���z W59�sL�%�ڇ��G_��Kp�Smu�$\JU�,l��t��`Dt�O��g�G�s����e���l��CE�i�
����<��Wݠ|e��ۿ����!b�+o�d����8�h宊f�-�{�^~MQ�D>1��&��4��j�;5��@���/�Џ���v��'u��eB�X0_����9Խ��e�0r� �
U��>��6��4�<c�<��4*ڹ�P*P�����o�\��60r����y�e��1��z5Pu��(��7�$������qUɜ�H�Q�~ �P*e<A��&�I��_��,Rᕜ��@�<eێ.
�b�#��{7	���P��#�:����eH���:�XX����4��t�ҩ	�x�ＫD1��N �I��8N�#��[�����~�A��������__kY�qLe̡$�<�8EXu(�a'��� �ź�������H>�o[x��d��T������6XNcyI�w��d��R{#�d�t�rc:�F����t���8�6Q-4����d�� ��e)K�n�g�t�Bǰ�W�M%r�j%���7��'�wT-��ʤH�����Ƽ�����x-i��++*������ɶ�_Cb$�F��<��Ƌ�	|h��A0��):w��*�{�~lW��
��!O�*�dTG�PYy�e    P#z��x�L8-��6��`ƹ���7������K���'�S�����r:C��CpC �`%i:�`�d�h�[wJ���2P� 2[�+�K\&�5([�!��$C�;]��65Q��)�|�ΛdG�r'�� Y���7����Z�A��*�5��PM�����������y� L#0X3[�5��Zlv�T��%y����p��H���[�m��H	�؟?f��� ��p�* �3Ugt
�'=��#�1���k��2h�k����y����b�E��Ղ�W�1@����[�Y�Pp߈e�\��ʨ'��/���I{2���� ���_-U)(&U�`�r��C����A�w������\���T/�1�\������?T���gq���E����36(?�����-2�+��k7�Jn�z���n|���%��aKҔ�mB�x�Pج�����+@����!��o�������~É+ZǢ\z��y�cM@?8TT6�"{�{���	���?�z���*٫yzlu���9�E�<~�%�o��	�9$v�/�������±o��-!@���,v��i�}����R��mM�S����~��k�b�3{��{=Q/\��  }���%!�YS���x´�`A��,ĵv��@���LpN&Hz��*j��خ���S���K,���XW�M(���.�QI']�S�J7� ��
��m}��f����T	�@��£́/�۬�2E�ԉ�t��oz&�D�<(��[w��&��/L������(��� ���?fk�����ζr�2@8b�� �աg�=L/f���3��QxPV��&l�M�~��P��_��&�E��8�e��P���#�^�������Q����6����6 ��II��U�j���.br�z]%{�6��7����|o�U_J��!�R�9�X��$�� y�S�{�T{D�[HSN�+%�}#�~��jM�"��ŤK,���: B��ip{�$}+|k@��i|?�g𢡊���,���z4| ��?|$$O�yϰ�8�}o���Y����]�E�7r:�~����e�0sD�Ԣ(����[X|{݆��?EbEB [QY�d��j�f���&�x��Ͻ�t1KFѠW��I�qQ�H֏�����T�£䫞�wnSn���u{9z�-�����6�4t�
��+*����.Nm
�`�X|RK����`yVq�->
v
mBݠ�A�MɆ�~[eǈ d�YC��$����ߥ6Y�qF�ϧ��Xl��JJ|�R�@�m�Ӂ{J���}�H��?>'���u	��ge+��G�_���:���wtx�3^�bT�¬$܆��d�����<���'��X�(�\;�X����qOy��Z�Km�;x�P_K�¿Zp�bSy��)�����`�RD��h�:%��6�)5R\�)���{���r������ņ2��%��6^�;��\�NP-K��'�m�;���X�=�4Co�C� S^�'��	�S»���\�����񋓥)%z�=��V�mN��n$�ڪ/WUDҤ�@0�Ow�.+K���+98�����ŧ"��X��O�6���$p��ؗ4�rE�`��h������y��T[�  �z� ��6�m�/��T��a�@�8� �������9�}�f3*�ࠨ�	F�R�na�¾R��Z��,�4�q��㞌]]O����]��J[Q������P#v�O���+�$��_�7UD�y��S�;�[G��܇��5�)�,a(y�W�UOuO4<P9�
��ⅺ�L��%;l-~&*��խ�.���C�^�|�*T��J &����v*�
E���M����:�*Cv��W],����LЌ�P�Ǚ�������v>�
:[�dbZҔ]��>|�E�BGS�ZT#t��&+5�;���qqZ/s�s�6<�^�[X�{N�7Ǣtu�eP7A�Y���Q���x2�;�\ջ7*ѡ(�6,G�E�b-��fyI���Yf�z=ш��k��~U�|�=������+�I�8�����U4`&���#�k*����� k�ň	KB+��
�O����u��j�O�>��!h���WԘ<�a�P<�|h��ph�<4���ͷM%k'�y������bRE#��e��	�p��JJC�kxO��~*R�{��_�O��������KR3/u<i,��>��aA�*���]~&���u��D#u}�>���ۋn^��3��
�4]}�ЙdaT��R�Q������ȧ��@52g�Fgq�~�һ�>ma�#�%x�:��w�XS�������.�RVTEA$#�L��vj�'R�L�� �(7|��۔>��`��ң�����y���l�d�L=�����ɺ���!�?�Bi����wE��n�;���
�&�Qi���-��>�Cߚi*��w֒ã�ۦ}��G�;�҄������-y"�	��g����A5�fz��T)����o�(2�A�z�ڪ쾍>�%�x�,�Ϳ�)k�ѹ}����"�1���.�	���;bq���.��d�"d+�%ͨ\`*Ò��E3����n�{�[!��Mn� 	"D|�*T���dZ�@ ��z��s����JY�q�A�D]�N���d��o�����+�#��8���F#YrI3�ѡޢ����]'��aL_I{�"� ��b��p�SH#u+$Y�3�?g@���@5ZW��R�pQ=�o�ex�_d�g�A]�_엪h}��j���t���������]?Y��{}
g(��F��NX�YW�~�(�*{oE�:�J��s}:6�kɋS}LWԝ&�nu������(њk������Q���@Vx�O�+�i�TN?D�L�=��G�f��qP���t�"�'���[hL,jI3��Аf؞}�>���%u*��1�|9�Ƙ�fP�,�[�j����v���N�}1�Ch��qt�w^���kZa���^����Q������r�M_������O����\O��6A��V;v���"Pw�/�����/��U�����D�|@����V��.|R[OI�Y@�)rv8q"�ʯ�N�Mg���1�)5ZZ��.�-�R��b��]�}����1T� ��ۻ�����t��BՑ(O�+I���`t(;xH`�ۿ��U��Y/�L"���
n��zu
�c�feULqJ��0s������+ �J�F�L�eq}C�t3��vi�nO(�.�� ���r�55v�J�&O�G���H���%����ɪ�5���*��K',ܡ͟⢺r-�����K���DAs�A	�J�L�'_sqYh���pO�M5�_��&�b������EB��'žW[&io1ݛ���/�&_��߲硃e*��6y]I��L
��[�ϼ���.-wu���������i�:�����3�F�x����=D'C�)d��P��Kh@�JE��0wwm����KT��wI3��nΞ:�̈��zs���&O��  ���\ljhDm��$ď�&?�o���� v_���c�����8��=:�Ͷ	�qe���h�
�s����+����ez.ZK
�rܳI�;b��:�a0#�
%a�-#cCkvM��h���0HHp���Nf�Ċ���� �ʅ�.^�fm��(�b;s�<_n�$���q�Z�#�R�ERC�4����eD�~4�ַ&uO4�_�.g��W��Ȧ�3��ѻݤf�yJ��N�C=��|A�ϱ�z&O�̕���D�i�R�g�"�@h�w65R<9�^L�S.��L�M�"�}�YZ�O��5ߝW�ܤ(!�ʢ�G��8PU܆I��UoheA��$3vc^��M���/�:k�b_�T��#��j�Ѝ	��BA3�D~\���TP;�ZS��SN�2X�4$v<�Q�F5	5�>���x^�u���	bIglA���&��&�C�����kF��o��Y�o(.���8����X�Z��g}7��水�f�K�xe��(XܴS-�a���@1�y��s��r��d�0��NHx�̆.&��[�+���7�R���dҏ�ݔצ�    �^��:;D�~�b�n\�4���0������kpR���F:�s5?�K�'��)ĉaa�����u[�S���!K;&h&��ND�e����+����(]��W�r��_vXS%���u��ܮ-Ё��T����:��nW3�:W֓3�i&,fŋW�k�3�h�Q�oB���x���$s�<�ep��m�=��08�Pl�94X�YTګ:E�e^�j󡣆z,#��u�h��h�z��6���)��T!f�����(�f'��S�}�����\R���Y��9�S���}�L�B&۶�l[�,f��
�팚���p�Բ��4�vŐ��7�ڼ5`2��M%��G"4��s�}��9�ⵟ�')�	�X��M_���f����x�%�A&`�͏��x"��������
³�G�2�c��I&k�O�ٺQV���.G��mOe%j(Ro��N�--�KRu��B�\Y�P��z�ͭ��U�9B�x~>[j9���K���xY�޴Tƣ#xQ䀟��=ߓ��B*�)�_ˌƓ��m2'5OC!���f��ڄ^I�A�3є�}��7��I3?�5:�#H.�Ӹ{��e���&3�lᔙ�Q�"�e��=@v�z�(�f��y���^�F����%L(�lC�3��)0�{�xF}��4s?�3E{�kx�|�7�s�ϵ,,���R,����sI�-����K6X�,�<��}�\�<��o��qGM��>�����O�_����_X���-��sY�rX�I%�R~��t;[�׋lqg�c5Ô%6UN{����'e!C�r�@�S����s�It�g����� �ߪ	Z��?�c����1�ńsx�4�%�4�[�����2��(�C�iOi ��e9԰R�[�!P�o!M��U�-�ue��`�_�e�L��d[�7'���Z6�jY�y�X�A]N�>�Q�x�-����2�Z���M
W':��y��*Z��4����9�B��4�l(S�9��~�,�-��L�y�"IJ��w��OO~BhlU�[��/�0�	��<K�Rty��`-�wղ�T�6v|�x_�,�y/K&�T�|�i>�^���	�x [��%B���e��$�1qe�B*k�U!z��ҕ~@ԧ�-��'Y �3�*�"N#���I]�R+l�Z�qƖm�۫�vTvۅ9��/�jbB(p9�/	��y��]]9�kQ_.�}�	�LzpP��*<94�Gq_})�W�$�s���zFЍ�|[�7���#�&�U4ar`��p�_�n���6��Y>ebF'��]8+^�d(�3)�y&9-F3
7���gʛ�gz����{��xx��K���m��Y@n�i��5�oQ۔�E#�
�b��D!g������Go�*H�4u�ԫ)�V8��d+����ZA�얠Y�_"���m�>��/�=���rue���kX�~��0��fE�.��F{*�w��O&4�B�uU�q�QM�K����>��aJ�( b$��p����Ϗ��ǲ���zBMr��9���Q
�O�й
Q��җ4+��#WϷI7��T!a�������E�TtT��j�b�$k�9���]_v��M��bHEG�p��i:D��s�3�R�h�C-���@Ҭ�we�����Vd4��Y�ϪS*r�a"6Ka�A���<� ��~�ܼ-/�(��4n�-�E���� ��.��D��(V��}�G�2eﻗ�!�����
|�Cm+4�O�jl���J��VE��m�*\�����F����2��h6$�z�F��П�E|�,�����5d���*�4j�:Q/�gؤїSR�U[����JpGa�)����5��k7���e=��I���_� ���F�8��#��ٍ��&������w�zwiHe�����"�H�8�^�'��p}�<1�p�S�1�Mm�%M��>C��L�{�@���]���$�1EG0�а�io=��gZ��u����fR�y�T�-HV�6p�1��>�����C��{4C~]R<�֠��PpU���F� Y�ߞ�<]Eoo�{��Y�f&^w���,[I"�z����q_�&��:��jinwV��G���Q��l�����Ho��6��-�L���Y%2�Ok��M~ܨ:�ڦA�~�����#�GB���?�F��h��g���ư�~���ԍ�Y;9mSJNf����%g���_Ѱ��v��ގִ���]���5��J�����WI��.���C���̤bC�����g:R >
؅�*�~ ��`�YP�D���/�b����S�hOh��6�9�h�342>��x%�VDv��b��j��YKٝ��-�U���� ��4z��n�I[]FSup�]_i)�����x����Z\��Nm��LՊ�<
4�<Ιd�.`�_�U:T�Yb�eY	��� �;	F����t9�C�(�,�Qh;,���M\8���l
��hk_��gyoO2 DpٚA��PD�C�i�����ge��C��h��#A�u������E�g����BO����X�/4��~C[��5M��a7��(@��������;��c�5 �� ��s���ԁ�Ct UU�,lI�%�6�j7��3����3��%.;�S��<�&��+��-�&'~Fi�F��؇�V^O�?K��7몭H�4��)����h����#�_{]\b\*��l��N�8|\�[���k���~�f+>��$���a1 R���*"���������}�|�T���ג��i�D�b�\��Oh�I i6��0��:������@�B����t���� �N_��f�f{n1tFj��!�ȫb��	yT�ڽ�6��0&[@��S����!�G���j�n�Iĺ�6{^��w
e��&sj��bͫ�q�X��@�3Y�Ϣ;2~;A��K<�-{�4���=�aQ�u��Ԛ�Y4���D���J%�ʈ��Y?e���M��@�C�3s��7�ӳǐF���*�XG���e+�i�A�J*�h��9�BR��d��̺ﰔN�l����|ҕ�F�9�h�n:8ФS��*Jv�a���=��uҨ_<O_�z"�˘c�-U�YH3�/�v�JVt��:l]T;��I~�����,����_����ޠ)8t6eX��'QT6�<���gI4;�}C����u��M?[�mǐ`�F�5��f�L�DD���g�/)��`�A�ן'��K��Z�G);ʧ�T$�G��$;Ҡ<��*I���K���sT~O�S�-D��tr�{�g�;4nNA�4>N�KN4M��*����,��������������_>.�������6���CxTlVfA��N�lf��A�O����:�3����n�R^.����Ve�Qa����̲��D��vqxM�$�y؆�MQ��}��a�g��a.�D'�F�ą-8x@�q.,�]~�d^Cn��[o�*c*�H�5�(j�}�E)%��,ʜ섌����l#H�ƥ�-�ҖN�y�lf79��%���㮥���|���(v������4ӼR�����sx0z�_�T�WH��u��1�W��ls�Ki�K�����W�D�r�d��qi�_ݯ�n8K0�04
�eW�umvK�"�#Z>z�5+3I��	��Z�*�{����^�q����E�T+��� ��M���qO�W�ּ��4�ۛ��m?�W5��R��14�I���0L�'#K�c2A��C���}s����P!"Ө=�{e��8Ȱ�b�lhE1���Qt��'ڿoN�;o�h)'3\���)6ESi�dCJRU��4�,H8zD�wn�ǟӫ1�nyuW��i���h��`��T�f�Z����y��	+)e�i�I���K/֦P�F�3��ږE���*#��N.WB�����;F=���hw��M���B�p^����s҉�şB�~�+����"���G�K�@Y .H��mx�
u̶'魶��u���Q�^ƺ��H �(Мذ������SU���d�^d��������a8�,�\q'$M�Dg�@�;����h���J���Mp�>n�O��%:%�9�|�$������X��A̦�n�G�>    d���4��L�0�d};���$cӪDVMg/��T�ɪcS'[BK�I�a�����9������Ov'��Iz�L3�`�($Ly�"�xy���yN �{���q�л�H��S,�	�7���[��<��t�̰��7��b��U���M[�e��/�1�&��ӥ�_U�ݦ�h� *g�Bp�����J���:,x���aS����:�a���d���kM>j  ?՟_��H.h�e*r��<As��jI.H��zaLi( ���]z����iA��8�c@p�+ �b(3�3��t�����= 7�':�H	'C�z������Ŧ8F��$*�5������]�uXN_j�e��8�����eW�ϻ����P���r�X���� �S�IO���79VzЂ�^ى?����_b̦wQ���B��r�ĳ@]��=�3-��kAr<�
�KP��8��泓���o����2%����i6]�Lv������fb���J�����>�R�����M8H�$�cG4���d���\��N �%;��x��G�Uç}vԡi4L�x���������UfC�5���Jb"�-���ޝ�g8T@U��r��)/�5]�G��:<�&�fzZ��w�G�DQ�Xxyv��"q;�ˡ�:����$�o7	I�1��pD^�}�פ.�}*�&���U�����^�<��!x0^>���el�T�Sf]�k���^��x��$��6"�y�QNzȚ�9>���@����X��㦈n���⃧�6��WrN�%5���c���L]��$�᭗���O������":	���c�tz̈́ZmB�X��L�w��]*�����ͩ�y���ʂR�@n�ĳP5��D/�P�H)���к'�B�Ӂ�.�PC���]:��?�oǗO_�SL���6���J��t� [Qt┪�h^����*�@u2��>y~~��������e�P��-��&J7(dF���l��p��&۬���0��������lr��,�3
�
�A�?����Z���"{y�>��d��R�����Cs��T�%{ˀ:I{�< �kPQ��%�>���>1E{U���)ݬ�䊋��2{:���J�>'�9�|�HJk��.ꊎ�j����j ��$g���p>6���y=��M�X�g�a��Ş�Bs~Zb�Aww��>LI��)p>�ͧ��I��N[/����4 �	��xF����':�������e|v~���Φ;9���h ��}ȏg)�-�`��xMy�7):"V�!�v�Џ��-z�l����{�,�5C��z�p��.��t��,�i�ZX�	6�"Ar����U{��x^��PO�I��DT���`�p��ͷ~ڷ�N�D��9�k(�U&�"7���3�F�J��* L�����,8����'��+��O�BW�Tg+8_Vկ��t��:��m2gt8m�=�|{��a�bZyɖ{ 96�F���(��-������Ʈnw�K��_��%�&N��qɩU<TXJ��{l��4�c0�p�ޒ����<}ױ�QF�Nk#8�u�*�iz�8��aĶP�O���s��:~)����|���FGQ>v֮��T���r��=�_/�:������ww9~��{�Kܸia�Y䌛ԩ�Q�BO"H�cԧ�}_���Ke׺���Lg�!�ol؇q�OCꖋ�@�&�Qɓ���3�IoK�+?���\m.�go�Hk(����YI�X�
Ө�� �J����B�)�:й��=�*&@�@��ۏ�K>ٽ@C$��^����[��#M���ʟ������zK��Y�~8�9������P�J���>o�lm�|�Lr��ٌB*�K������@����&���q�N���&"i��/^��%�lʒ?�]�~6L�E��P�10(�k����.>q1�΢��?�m���f	�-p~��b�������}�,��<�֧PM�j��I��v6e?���/y~���~�[�]�K1<]�b�Ǥ˦3��4J��'��r��H��	����?�JC^{"�����W�N/z�ˡ��`4VS�����\�OI浤q�kU����v�:���ʒP�`Y��L�Ք�ޡVJd�a����]2����^���h�A�jK�Wd=����qQ�9Q��KO���T�ͻϔ�c�Q��`=ѓE8�t��v�'k�c��N���=��^�k��f���K$Q�����M9D��a�vY\�X%��+3��i��������FC�R�Y�UM�*LD ����F��Y��K4��vU��x6�����%������rW�$����A���E�:��I��'K��D�d���r�b�.�e(8Up
N	Y���y�;��j�et�$�y-�9Kû_��氚-;P����$��W������ﳈ�֦&
���Ż�� �t�:�(YB��K�hx�kO1������}:��'�/�l�?�w���g���P���s�I�<��e�}�&�8�~D2�]����^5��cw�2Vh�O?U'Js0j��X�Z;L�T6*���>;c�\�����4̨����N6�V�k4
#%8�8ٖC��H8)yO��Wp�Q��7S�̓��"�+�Wi\�I���
\Rt��0]<��&
��VN�����`e�k���G6�m󄐙M�|��R4Lk��e���_�}w�ba���Y_ϯ��I��Տ"'�6e�M���bQ���+I㥻��x�~���F�3�����Uv��M�"鎧�$�m:U��������j4��+"$�'i|������d�tKs��\Tሁ�I�/�uzͶ��j?Ѹޫ��{��{"�d/��nz�:j��Z��ŜF�\|������dy�ՏZ�<A��/�������:o��OW	O�^�����"�q�u{xF���=��nݏ�lmk����|{�)�TFe��?�Gb1��@���3\IKo~_�[9O���VL[ Mc:p��*+����G��DX5�!j,�S֑����җ�z�`3{5�P̝^��rB�j&��١�	��$����t<og|v��n�'�L�^54��M�*�tƜ�c���v�5�R�����q���MY�����֗�_���	`:T�F�(�`Ƈ^b�� �{"���!��f��Ξ�����㾣[1��4�!4E8X����?�y���ϣ�\�i�I
y���h���!�P��ݔ 9  *�������~q� 5�,t�6�>At�Czѐz�7rI1����L���Ŷ��S�[�l�b�W?�X?�x|^V�����S��-���\�4�؊K���2�y"���+����0�x�k�ң*��u���i�]�UaC��G:��d�@5��ހ�{as�x��j�K���۷���6�1�����۴�Wɕ�����8�V�L:� y�Шz>�)�롒@7�Ɩ�'!@��QO|���0�
:�HG��4O?�,y��.��`Xՠp6ub���#��;�ېP�-̲ρ`�̸�ul�cm�U�N�_���*�+fP��}RaTѲ:9D�feٗ�9C�+$�<̬��On«�š�:@�+�ڄ{�ѭ�Dvw�ћ�}8_�_��V=ѳܸ� ����M�?��i/�-��a���(i�l�k�nB�鮊z� �yٳ�<gWV)����K���Ktr�������U}��G]�U"����8Y��'Lo���s� ��+v�KKIovɹ@��1��`��k��Rz?��8._I�ج���q4g��q��
%�>9��^>YfP
�D%��m�ŝ�:��r ����٧kI����F۷��4:�n^�`(jA��An����h���"�v\u��I�8� ���~�m�Ԏ/7�S]�R~���ytX��6(�� i.`��o�n<�x�/�/^���͂g�Nd�y�0������*J�E�/<�`M�uX����@���Zߟ^�/�\s(���T4|�:�?�DOC+�Hj�s��|s�q�_yO�V_-���K�_5ٽy�>|	�*���ᅠ#�@�+-��گ��g���V�t/���n��/L�.v�e�?[��ۼ�����_�YMr
�ěf�e[�-۲%_g���x�y�,��4�Q      ՙtuWP99� ���������_��y�"%�ۓ���o4M.��^�ˆO�AO~j��}�)	 ģ�-o���F�� �Ӕ2wE�	������z��JƯ�Hk��P"
�#��v��&��A+��%���t��s���zh��������0c����;�����_2�T��h]WV	�gEᬎ�}ƟF���e��7 �^'(�4*��[pi���~�t�BĜ�G_g����F�� ������4�������9�����J�ғA'i/mc���0� ������D�2Q���.�ߑA'=�~��~~��Yq(�ݐ��. RtN�H���2}+9� ��d�HÝ���yH���������5�,������l&�;9����N���(�#�������Th�O(Q��{矀X<ʹ��Hy��8B!�1g��u�$3ޯ�ibs;9&��j'8�n���bGz��� ���!���γ��7���7��@:��-�	��u��������H�4AXƖ#�N������/Ɵ��2�<�g�J>ˊ�j�������k��ݠ��v9�?���_�m�F����څ[$�da��1�s(+J�mo�>z��Ϋ�BT��m���i���N@:x4̳� j�.i����9ð�Ůq%�rD̩G�D��Q� 9���ۺq������"�F��ҡ���2�l�dv�шc�cFSu���F^���Ò|+�sk��X�������jI�n�H�9�{������c��N���]����=�Zdд�d���$I���lo{2�|~�򮭷���v��ls�t���f4Z��+lL��eSB��8��9�#a��鴜]��3z,E��+��!�~2!�	|)�]R,!wA!g�Z��xa������l�I�D�i߀��x>�X��J�[wl�ܲP��t��A��bNx�M>��ڞ'������KTE!LU4@����A�Sϗ^�9^�6�-5�g��(d�U�6(,�GE[����D�ُ��v��=�0���I�ve�#8����ƿ�L!Lx�6,V��������V$��[h�nt{,t� �W�^ﶿx*n!b�c0��+GC�
��!�{�� ��xOQW�u�����e���:{���a��C�8��TO=�tH{D��9}��FXN^	(1�[���� J�~m7�)��'].r��;��k�_���@ɕ� E?�ٞ�����R�&ٺƱ�z�]#3��ouI���o�P;�th�t]��hVMqBs�A[�]i��>�����H��v�o�8�9�uaO��Y
�{_b$.�u8�Z��k8�jw���󄇾QZM��,�ZP����Wq�NMh�ç{���i�ܞ���??�W���R*AR��u5�"�݊vt0_�1-iXAٓ��߀GN�jq��gJ�
�}L>^)I��L��y�S�v��^C_���Nځt�/������;���١�������Dz�$DSt]!$�S��Hq\�6��q��8��pՀ�|���?���R<F��'��m$�h!�b(��]V�7H�������>���(�y�崙k���&���Ў���}w��)�.8
!�Cߟo&���~T��2�	���Y��v�x�3�b��%jT4۩�]�"�.����7�7Q�al�`��f+�T�����aF�]RQ��96��b�E��^�Û�;֥󸢽.�d�������t�������ۄ$����	��ܭ�g鮠AQ�/A!�t�O������.�_C�CnDu�s�V%�ٳ���V�z���1��G�7]����f��!F2��!�z9���&�GoL�iQ+i��c���|���_�Cc�S�����c��I'��n�B�Nڭ���`�f�(Lg��D�ԥ��������c�vZ���>�!���?���}Xap9mh�&�>!.j��l:5�P^�]���-�V�#����xrԅS2�Fv�l�̀5w,��^]�f=д�n��h���E��gDW�؜�Cnv�#rw���<J�c*8��������'ܭ�,�a
�$ٺj4�D���ma�Iٱ���%CƖ,�1γ����5s{]���?я����+_⩙��9w�ͻt�..�h�7�Wp�@�e��z,F� 9$��v��4�U͆t��릁r����N�k���
�D�k�G7�5$S�Q����\����e�10�A��Ѿ�a�����}'~����d��Cny�\��&��+FOt���ӯG�Ɇ2��tT�{�f��۔]%!<Z�Z�j`;y]�m�+��ku�#��4��N�X��D�h�����K��Qĭ!���c�92�6t�#VvNy	.��%��<:�0-o�K�z6��ݴԇ�v7ߏ���{��K60�~Z�K�� 12�9��G-Պ�1��&�n�YC���}Ϻ����tٽ��Y����Ô��q��y��Mx(�"�~���Q2���/߮؋T��Ōݯ��+�i��eP��@xK����#���V�q5/���\���v�������d_��s��z�Rb7h����r�8�b9Qt/�[�8j�Ц�\���&��6׶���ږ���:�Lx�'���H�K@���b	�ۺ�\:�זF@@PSR�R�N{
p���_��ɍ�=O����P�ן6zv�a��.~ƄΆ��{- Ɉy�o������m��h�>7R�T��cxb�;S���s�y���A�U����nX,w�Sz���6Z��zƩ:���h֑0�%n�La�!�e�iA��v��ΒoLU��;�R3�f��~�h�	���!O��\�]� �cX=��l���$�mF��J�`��|!�ha�[}E���~&���eA��wٱ�ܝ �$���G��uoe�L�-�2虃u���a]Mn����\6T6�. |��F� r,A)3���g{�<��b^��w�P�6ZH��ķ�O����Ht�RNɼ~�%i^9�����|W��ƺ+�j�.r�aNД�dU�\S���L���Mdг嚾P��Yw�������}u��������[��Y��>Ҥ���D�����Z
%��;��d���J���� �������8����ޥ\�q-J5�Ɖ���}�D=��D���݈��>�xX�ƴi������8���,ܴ����y� <���l̆�h�s�Ɵ��
��3�rټS[�S
�[m7.���%�<��N��i�>;V����e�o��2�f�JO�go����d5{�[9�LG��(���=A)���4k�EX�:����AK�eQ�q��{�[ǿ
/��{�#Oۓsg�l"�хM�V7�T��g7�6r���k��A
~�t8y�<�R���&I�ZJtrѳE��Wn2T?�tz�N,b^�S[d�=x�KS^�-X����K�` �݅o��4�e�Z���<�*{�5o��wȧj�-1+��f �$�y��m m��x6���w�fn4�
�<(��t�j��ϸ��2xL�|���7�L*�^Bg�A�ܽ.�M�Q&4\��O�8�r_p�&'c�*e�K�5��բ�8}8b!�[��=����y���Y�W��Ӟ��[#e�Ϯ]�2��`���_2�?�/���[x�a�-�+��(̱�t�-�i�9���)fk*���-�d*U�����%m-}�����	�;��q��ʲ1o�X��rTk� <���d�*dhL^G���ھ�\�L�\P� �2�RVky��S� N�)��h���U{Y�����t9 ܨ�GY4(UZ�%�m�^�}̸�z7�m5]����N��}�rՂl��\$����3X��E�+�G�yo1�~��Y����ן2�d��%u���#uQe��S�ڄ��ȡ�R΋�N���XqQG.7��>]0	EcӪ|�S^�^Т�4{�dЫ�I>^�yy|rV-�N��:�ަ��X�\����%J�搷i��Kϟ��s~�μ<�M�����r]�KnB� �5;��`M�=�o;p"��J����m1\f���������h�|x�sz���a��G��g6�N(b�'�6����"���]    ����{���N�9!=����dW�[Uڊ�
HZO��M��kF���E<O��Ƹ�P�f܇N�/:|#��H�q7дu�D��w����f���B��_���G��p��Ʊ�)C!ПFC^�S�v�ΏYP]��˳V�	��l)�2d�G #�g8s�.�鱆a��C�<|0�o�aE1��c
~M /ؖB�X�c*�6,�dGgO���)|P_��/�ލ�m�O�c�r���.�S�N��0G%��^��ǋS1*�E������Ҳ7�o�㡑������%��N� 4�#�Эn�!���r�� Q����~k�g˰�<СB7Ǥb�:����}��]鷙8#��C�> �6jHw;�<)�A>��Ϊ���](�Q����cfo�!��*�v�>��ۙC�|�m${v�Wٛ��/�����Z�Ìr�T~]�>���͆"~yv�9������'�v@���S�|,��y�	�ά�mxc��i(�Β�����+&��o�oQ�#���6}ᣞ�Ɔ�P�hy������J����
����Z7:��g_���\�&GA��hېL����.E�lv����G�t'�+ �G5�5TG��F:��� Y0��J��C�s�+_����M�NN,#��A��+�Y������~�����a�+k���_d��{=z��oa��KcX1D��l��j����R����P��e����E�7-���q����qF�=e�	��:=�g�	�l�W*�Oʦ1��ݎ�jw��2�~�_��M�^)]�3�۶8ƬEW�CL�i=q�_~�XU��U�}r��AJ��,��[v<��.P݈޷&u	�?l�I�r��o��Ö�S�G;�����0!ʕst���O���Y�jݝ�^�� W�%����Nj��o��>¶�G]a��j��1?�~�\�c�S�m�\�x�V��fS�@K��#Sΐ)��YTJRM��O���@����}�Y���Dwt-��ЕA&��JP��\��dᰖEȏm��m?_�y+@j=OR�]���^�QA ��3ѹ�1?9��>˞�=�Q�T`�>�OT_���(tZ,��R��Ȟ�2b��e�!?m���}Q��06�<O������Ode�c�mgPvas���f������ȼ�-Ş4�ɧ�$��j���J��|��y"=-^�����~w��Э�y���o�cQCV�XH�l�!�֔�l����8����h=]F�o���];&1z:��Q����U&�ye,��b����1zP�����m��ϳ̎r���Ǎ�V�o��e�����!���G�>)�b�|�J�2��I%�-�.���z��:�.�f,����`dp�/Tr�s�����l�4tqF!e���hDQ�7�;���Z!nġ������.|�>������㤲;��Ϥny��__�ӌc~=p3G�%�^�ǝ���}�:0ðѴ���)i���Y�V$�rf�˲�.e���$�jKu2>��t[W�^G�`ϔ�"Vd��F�o�D��5[ˠ������ ���)�l����?���oR�Kȵ0^�eͱ&E���9�GT��n���fty��=��+������[�EE���wvM�%}t����;Fcb�Bh�iUT�ːC��p�����$�q��MY[�zXdH��y���^�7,��M� ���������,�y|nP�Ļ�u^�2����J*L�KΑ3������m���?'˷�Yo��9��H�PG�ڧU��v��(Q
%����/^�D�� �����n�:^��y|�$�>.�?:�<^��k�ˣ��C��<-���q�=?����e%@q���Q%.�c���>3{M�Ⱦ�����e����}�<�?����0�3a�2�����H���v�����7��J��4��@�8��h�M%��eEX��Oe��%�e���i��?��\zC*J��C�TR�CK���{x��=�ϯ�Ӥ{��J4���nYb�YH0��'�aoí[�vܷ��3oTϺ��
����o�@ү!���@������u��6��x�����`@�[W�Љ>��&�0x��˥ݶ:*-yD����py����	�/���������5]MU�}��9�[A��J8�,��x�nt�v�
.�t��aa��J]�( h��#	��eH�gˡ��}ů�����px~�j���r��=X}'�P90���Hf����m�K����"W���x;ng�}%��$�5�i�`c�	��1NX,�&�t�mܯ>�$J�e T]�j�Y�'�$&�?y���M�L���; �/�d^κ�O�ާ�vƊ�h��:}G�`�P��TQ�|�]-�o�y���N����A4T/��wt2Ў��OtҢ�L̲BJXYrJ�El���GZ�fۛ�ԇmO��FTi�/W��} y)�~D�j)��1��� ��v�}uY�|+�S�:\�������?:���j�� �S�v�]T4�$�YWҪ/C�ҳ<i����~Ԋc1auQ|��ӯ�����5�bm�ɑ*�$i�mK\F0�pD��n��/Nq��Ρ��A�lR�C4+ ��� ��	�J+�[��|�uժ�w�S���~�ߢO���k{������uY«2�!tYk�=�(O��&��I.,��G��8}O{y�m=����ÁN��b5��b�1�x-��d ��&}���̝���;F^�h[v�ܣ.�~ ][ㅇ��/���c;	hHnEl����������*8� �Υ��~�ߺD\'�K�̾g�g�cpf"7N�4�2\t�8�q=�)ڠ�����FNu�}�\�?��a�X��S��`,�t��띝ҕqvxhna/.����Ipsu[�)yNm����ϕ���*TU�,��������x#T�RĖ�N{�|Ћ���M����Y�R���3}f�X*�������в��ZJ��Q�3���G��}���aF[�n����Z�C6	��ђC�R�yG�VW�;��NU��[9͡�d�XYŎ-�$_H����ز���7��i�=�G��ib��Q�W��#\�Kx���ߜ(�� P�.����g��U�W��~(R.�a�jH0��"����'Âok(IΡ妙ʬ%]�Y��kg��Ȝ^�j�9�x�X=��Ĭ���{��-;Tro�&���@d��5�%uD5hq��e��ٺ2u9Р��+�?b��-?*�N*���<���Kߧ'IGR�g�b�5��� ���.m(��3l�����B���Q(��Wu��&bh�͇#����(mM� '@?"��Q{2@Z�h�����#O�lc��ݹ�梳�?T,�#�<_ v��}�ߐ�r(�4/�R���Hۤ��xH�`+��AQ{^��E���c�>̇,�QRˡ@�����ǅ>ی��|��T��]ڻg�Z�TzY�g�������n�#�?Q���I�����Vo��)[�G��v$�xLf�P�O"JK�Քģ@����{qm�f���G�CX�3�N��G/LkC�>��Wg�+����Z��޻�Eݩ}�U�>�hL1�����@��Q�RVK[45K�-����_�ZU�4yG�W�K"*�UMe�ZĉM�>6l�P��l�>t2�4u]
Fۿ��gUol����:��U����)K;��+O,Wx�XB`B��w�9���P�	�ۺ[�7oI�Ynt����-��;�_��9S�����1��_<fi6FJj�N��tn;����/�g��?Ҫemq@�vex��%s(���g��狡;��[;(�4�)N���c�b�O�q	#��b~!uA ������6y~~�{����<����8�T!YM���n�e�J���_(��s�Y_������f8Z���͚����`�L��h���ϡ��\�_^]�5���0v2U;?H�tMUy�s}�өld�x�I�Ͼh��7�̓�'��qg��>/�����0�1E��]��j,�(fG"�؎�bl�"�,	q��W��N7������.�{X�fH�⴦%��o��=��D,X~��*�}�1���հQ���N��Ԇ�1�c���u�A��    �� 8�,Ïd�d=^��:�I+iZ�1��=)�<�CK܊C�/����b�
�o!K�qA6S�W����$�b6�*É� :�-�?�K'�7�Er��(<���/�6x�5���Ni$�P�
V`��ߴ[���C�-gP���s,l�ʠ�F���j1_���Y*���ve��V�ZD�B�;�_�\��gd�)l9�n��l�.tTI7� �N��Y���s���v�S>��!J�> >��{J )qH��oć��{
��8uW˽���꿸[�U��ޢ݆UG*�k����7��)a�����x�}���.�W�����0@?�� e��B����:UI+$r�m�A~$F4}(�qַ�c��(9��'����T��i<Nh�]4���]�&2��c�����E"�7�';ϓ��N����r^ػ�e.k ����f�<����f�z�Z��y�<�3�}�\b�G��=^��P�N�`={����z�{�︥�ѿ�����
M��/?:�2H�+BA������=|RM��Y=���<;]зѵLx�0�<R�ǔ�pE,������=^}^�����J{�:j�Q�vE��������`)��v�}�I��e�"�Jץ>u�Q�|xM&������&��"4~!���cs(���^�ܝQ޿W��1'P�bԕ�_�����.Ox� u�,�%8���٧����_fT�eu1���?�2�(
��_ܪ*}������Vn�O�>k�'��U������vu�)�uTP�A����&��8蓴�2Q�rߒI��l�����0K�'�+���lx����|��F��m�W��E6��~:�<\��&��'�%�t��*�+��)��vP��&ȟ�"N�mq�?I���3��9{��v��	�<�0���L�2��6C�KK�����S-XS����7e��t=7���a��7uUy�y�t���,s��\rK������c}\#���=��*P�?�*%��ʶ�SyB��[4Ѱ7p)��|w<�T��x�PA����~�߸SK����o{�ߴ�~�2jJP:���|h�`E��AB~�$;���O�����[&wTv���rE7��ˋ��F$b���}ƻơ�ɭ�tK�B��J������'Ḣ���O��o,<x!P�J��h��~�r��b<l��A�Q��n�d��rC�w<Z7ي����hh��i��%��'���*�!s�{J?�n�-���y���)�����`#���_n����}��R�H�)]���/}|H�J�Kij�S��}J�G��+�#��{_EW�s�rv�3���>C�@4���9�o��}����O?iV�6�LFVC�g.�������ly��^Pk񕖿o�A�;4���v���ƽ�ghG�<�#�3���xQ�m����<��E�5{iu
,R_��+���.�k8������Ѯ���:􎌟��ٙ�v���{ݞ!�����#X(X��)"���t�v���W�a��Al�����n�6A��9���ݖe*b�r���sFIC�\�U�s�?,<���[�h)�:!���:�Q
}J�@�D,~O������֠�������^�C��7�jй�Tҁw &��0v\W"_���s��DI��K���;t(�gs�m��슎l��|�4b�W�R�Ѡ�C�a���&�n>/g��G[*���<�m�O�CW�y2�V�O����^C*�J= T9�����</r��|���d��F87?�M�w3�v���͈xWA$�̽.��u���ݭ`�
��bC�F���**pF��r�{�%��詋h��x����ҹ���~:���b�P��1z��b������j\��0xi�g���N����9����� f�ǔ��gP�(��,h�E�A� ��0;>�'ә��/����d0}X~����  ]HEMm�ڔ'��$��6DR�X���8;�[,7Oy!���J_۬��Я(�3���]�<O�����q��	׿7B*����N���b�G~Ji����u��z�K-��t%��`�1Xה������8}�������HJ�nLǪH�i���B�SL���s_�mE8,�<O%��}������s��|:���~�A24�[��qS�vٍ��u�JòQ�-#ٽw��+��nV��/ؠ�q%4����b�^K���;�`����|_��ƀO���wV��i�۲r����cT��nºi��ކqTÆ'��X�u>�GVTl&�g3NZ��Џ�rٙץ~�:�P� �$�/'r.��(�:���p��hB���mS�[��%�I��N'����������}���휥Ƞ]2�#��}�n:~x�����GZd�/��~�f�z�G��-��]t��Tv).`VQ�U�x�7�p7(��8���u��O���y�<�`���g�v���|��0DE`#�����`���F���]��{��&ݽ)�>\�Gh,a�LO(y�3m9�72	c��X��Q�r#���j��RΎ9�����V]NŸ�9����+E�iPr(R�[�N6O/]��-D@L3� �Z�:Ԝ7�R_���j�2�m8��n��4ս��o�_.i�-�-���
�͈M��b�ܬ�� ^��8l)OL)O7M4��p���\��,�@ۇ7],��jb�e�:2��P�C����;.첔I+9"�6�DE@?I4���{-�w��Tr��O��0�����u*��!>PH��Śr�(��H?0;���s��#Հ�I����(y����:s�F-[�y��#��}��A#hߥ��:ӆ��Ahzs~��
A��E�'��9(��l���C4����xʪ�teXe����?�@�9��(�|a-:�E\6	"�u�>6��=�@�`�2�c�R|mW Gxx9}nf��$�gW����|�}t_���guaq���#j�(MwBH�?�A(��J��c���~�φBxX�
AWeV���gE���(�t��Æ���R2a����,������Yp6ݽ��ZDz���`�v�����Ҋ��j����X�X��:���D�]��	��)��K0���G:h��&��!��E,�~�_��uo��V����Ȃ�հ
�(�6;4��~�˼Q�=G#��Z#S���7����@�=-WC�q���Q�?��ڍ�̂!`�d/��"��C��[��::N�z}�ڪw5@s����1�ac�ϥjWB�SW��� �U���1�P��Ћ��|��B:;������w%d�[�`�ݾ�qR`��Z��������7��"`�.����"�h/�|�b#Fd/�=�豞�oE,��x��F�������2h3-��@h��(���Ƶj�P_/E,Z}�&���ݖ�R�E�߁�o��㲵�9D���	���E�EZE����]	�*V�]@��E��\�0q�ѭr�놭R0[/��䗆b}��,^��2.�p�Lm`xtd9ey���	P_7�ѵ�+.��ƎAS��(�A`w��ۧ�� Hރ�ɉ���=�՜����b�x�I�(�	�]��U�nzӟ0B���i�U� ���6մΑe'�7�ǐ�(����=��rZ��4�B�,�������π�.<�d%��ߊ��|������>8�����ŝ�[��Ђ�����������k���|����,�β�ɰ,M��T�]����T���l}ߑ�޹V,�I�o�m�Dk�u-��35ͬ0�xU´���3��n�Q�}^>?XO����+g��B���E���>��6V@8p%y���-�Ǜ m�m<�~���?hS��3��Qc�d�-	ܩ81`!a'�3��]�-lCe����������Q��7W��}�xa7t�K�a�bL�SԱmZ]�����fPF
�2+��ިv�����3Qv!/[�}:
1P��v�6�-��03��"4�h�;=�7�q�[�a	A�:-P�mDnD��|]����PܒC�� ߄�������    ��`]Y�N� c�TE\�hdf�:hQ����E,���Ѹ|;���q'_����xn�9��+�]�a�vn˵gI��C$:A��J5����#�}�.��Oyy:��/�\���e�h�%���}%��� �����my%;
=aD�GT��AJ����
=�	�c�τ���2�R��H��]��9��:��P�^d]��+�]ӳ�n&�:��8MtեS��'�6�v�~=�/#cP �z75�BX��Te1A�t�!H)@�*W��N�C�?���S����u�K/�eN�1�H�X��߲���
R�Tl�+�X�'~�y�,)5��p29���� �.�����E�����@��Bd�wD��uӉTȖ1���M�*h1����!?�!��ޗ Uy"+���Hvno7ç�������7@o~O"ړ�=��a�����-�O,8�2�y?��˫KH�
� ��Q�
�#��/p��~�Ӂ9V����WX���֜}��?h������~_�l�w)�{�G�/)��7�D:���F�
N±��Z��iV_���?�������\�.��x�T]E2����(�ed�������I�Lୌ>~���Ԟ�AJ��b�qh����1&6Ӌ����x���.f�h`���2���&��,�CV�������;XK�6���79cؼ���ʕ��e��L#h����}�Z
��G㶒���o`k|v�_�5bzD��AA�Tڄ��=��_�1;�s�"+��	H��禸�o�*�L:��I��)�(yA?@����(�SD�"��(�V�A��?�ϣx����5�&Ӽ��=%Rtܙ�n�]Q]��nB�p�����{����::{&�]o�J���%ы_�P �A*:�y�K�
�q���SguU���B��?��m�����jʤj�������B1��U4X��ͩ�I}�-}��V�|G�|�t�ߘr�:���j���l-�pƣ�Y]�~q2o.�]��MT�Dx���hP���Z��)��63܁�g�vID3��h�����4�J;�O�[���ҠLe�>�-��SAq79R���-"��`_2.�U���Z�.�_P�{�.24�|�$A�)r����e�S�VX�G8@m�IzKg�*i=�T^e^ivU���ʖ����U%�El�*�F�b�??���ct�.1��n�t����^��9l���Vo�Ͽ74t�6��[���>��"m�^T��i�IA�5�^��׿�6}N��������A�gA!�"��w��x�ߺ�̓�|'�G(뀉�?��\��z],H24��b�AMW�zX�/1�=�x���کhC2Q���j��KAg�q�ڟG)\٪�~R�e]����?y�i����;��Q��IB��XM��|B�2��@KYMtUlУ����.'����N�F��|>0Y-UUv���q��.��C�����r�NW�Q+s��9����c|׬�\f�]����U}�K17�8��³���&�} O6U�t�3Y��>���js��S����O?��Q�#*g���@�z��k$��ʹ֦V�KDV����.rރ�F��kj�� #�>w`oB�Xf1&�:TLrl�I���?$�f��[�}- ��Ytbv;�/�~��Y���b�&����+�~���S���"Ŕ���� �O�V����B��6k��_Y����PpS��S׆P^V����u�Ǹ0i6�ɉ�̖������E,���������d��z3�5S�~�ΐ�hF�����*/[�˜VH ��P�i����r����Aʿߵ 9U�|�wq�J{�����;1���/�f��f���!)��2���x�9Re%��o�jؗf�4�yʺ�=�Ņ�d�-�n��� xF�.�ud���[;�O�m�A�3�'�Ajg��z�[�Q8���h=6g-�.���>�d�$�[*{��zp:�x�����.}z���[(��}n�0P��(���.�Q�j!5�+��׶�y�*�������,������Kp���9�[�� �d�ߑ���e˓֗�Z�6�"�K���̇;�༲M�Cx��_�h�W�+�u��k��G��N�v��:<�}��ߞ�ͫ!S1�>�8�n,rW���z7�ܘ��o5�%<з�tni���?0{ ��1�@�
=&�hzI����Pl�M�^�}��� @`�G%�M��ӾףC#n�W������qZ$b�IQm�|�Է����p�t����bu4�ü��s����U�ͮʝ�5�b�x.Q.���b�t�KE�,_�@�U�^�ɴ/�Ò-���FC)zbm^���E����#�~*m�Ҧ/���^��3�@�f��z���Ap%{�9��w�75���Y�������I�z��֤�0�- /t��»�¥l6�+&N�iA��/�	s�g	��ٝ-(�=��D��G���f8�~ �� ;!��S�9`1wʢ��ߜN�o>X!�<�ך؊N|�`�"��B���G�9&��~ 0ǵ���R���/�u�3��1�@P���m����_���*޿�q+�jBL��`��SS�����6�)X�c��Wh�I��x����~�7)}�2�6���E��y�OuSCig���`�>-l�<�?���5@vg� �{t� Pܙ��J�u����lc���^���+o�4}?�z=�����NN�˵����[�-��^Y�2����{n=�u�{��.:��0�.���]�}M(��+~lM����w�8;�?�uG���(�aօt#�����J46�8 '6�r�����Ǳ8?^l�yu��g���}*ov�x ��چ��n��O𼃎z;��x��sֿ\ޫ��2~�>��MpAn�����0(V�4���-��qqd0��������(6��]hn<�������������B�YI���2�6��8('̷��h�~]�v�a������A�����-ɣb�u��N�Sy)b�5t��,���>m�.$������[���K���Ċ�r:��B|����"9�w��N��U�xܗv�3���i#�A]�<�kD��HO8�<3�X �� ̽ڡ+�S^D�n]�nP~\���#��i#��×�b��jD*�j�UXC�	4���Q�4j!A�"o�p'�բ��>w�'F���Qx�~z^�uX���uv�͐q,3Q�mş@��y<��������2,*�����󀤍�CaJ$mۑ�1�A ��n����b�:{?�e_}��,��9ʧ#�Y�>��f�ɻ��U�6@O��`#&�V}�F@���P����ǂ����|}��G;�6����ھcq�vZO�n\q(� ��g��d�i�M�@/ᝳk�YyɊvh��P�Q�"��?
���ʿ|q��F����¼5ٹ1�U(ZS1'��˘��T"�t4LT����m��I��?��|��ʧo�@�����^!u٥p}Lz�㯺>���(��'��EJ�ӿQ5M�� C[��2�K���}y�p(�~�N{&�k����a��kvS4��i�4��S���L�!���l5 �d��D�N��-V���<������Xc��˦���>�cԵ�le�F�GG���ޫ��Nu~ �����F1��t1&f�ZH��]�i���R�; ,|�ަ�T�4����u��qg��������6��Q���|���9͊լ�́.D� ��@�B��҃��@o�OH|RK��:�!�P^�sW�/�m�7���)I�
�8���z�a^ h(��������?�s�ϰ4a��	�2���@
�h�Sl5l��x��P�ӵ4b}i:J��(;1&J����A6������^����� qJ�Eu��\�m��ϕ�O.����ét�.���ab�����JP�R,Un�D�g+xs?zN���a��Bv���> �4M����Bm�������T}ȖO�L�:,ׁ��	��oE[`L��쀚ҭ#D,YT�����|ݭ>C�����3�.�1���y����ewa]r(	4<kd�o�ަ���4lTIʍf
T82_]#��\
L�_����z��N;ơkJ�    �3F�k�!�tm�G4ՎM��N��<7-G�hP"�������>��_K,=K�ґ�nSD�*�`0�>D���O[���d��ڂ����)����5�O��3�b�Z<�f%g�Cg�ƽ��)Mb�B�ܓ&��M5}(۔4�Jv�}墠]|�F����^��'�4iv�,Q�W�E|�^43H]�c���AY�(v�m��mɗ3��9ētPSE
H��<(>>7߶d6?��8���i���U�ß�k�}�M�9�p���@-�ҹ�ﷴ�U�/gTH����h�Zh��M�7eU-��:^%h/
D�v��~�fu"�]�o�_��b=��X[R��Bۆ�K:NN�*1��A4Z�v��c�B�E�b���:!�+t
J�[�-)'~�we��N��p
K>lqp��ܖ�$
ñ5�^�=��$R0tni7k�_�-�}���6r�,�ؼ$h�Iq$I_>�T`.?Z�N����S�Snlt�P&@	�L�e��x��%%еU����,����tz�� �AI&0� ��m*m!�D��09}���na�Д�vY6Ѥ�.�.1M����3o^*m����-��c�e�>QHI�~��\K�x���|Y�瓵�G��.��_�f�%�@��؏6�ݗ[D�4�d3�l:<��	^���^
�~�\0���4�õ��r�v�1tG�1u].U��0��ضˏv�ȓ��Wܽ?D�]^�d�7�t�Z_��9T�IӔcdWb�X�9X'6sJ �z���S���w;P=g��ئz����]��%��Ȇ���hrl�lyի{����S ����[���x�o�א����\��-b�~P�	I�.��#}�zq��t|���
"�
y����W��_���/8�Hb)�i�@���9�v��X+����/o(ǳ��_��	�d��$K6� ��$H���9�����ĕb�:��G��0�̄vF�&L�z�<JI�?�q�'6&�:��S������@t"i�y8�9���I{�4_.���ptX�܀����R�V�/��R��u9�j�F�sѩ.֢�1�~.�|�t5:҄��\���j��/�S��D�|w�,��Ycc��?m]x�'Tyb���	�Y���*�%,%�:ʦ�PjB�K��1���|�|��r�\gh\�z��%]b�iT��p�4
yp�(��?:7c��3Uwכ��h�� �
�����u�oa�eI��g�-�Ѹ<󖩠��:t��<��.<?I���^XS��k�.��Zb7ޙ]��E�6z�=hq,�*;wl�%�^�ҫ �+���u3��D�v���Ƶ N]�Z@S{ ��_�x�o�j�>*�o��s�T,(���<�h���=���y��''���η2i8'Wo������&`=D��Lvu�������T!�B�L� {J�<�LX���g���*�H�4��l�Y�5NoBV����/c	x[�9��HK��k�G�*8O�_��7^��9�0�c���?���ʧ7�glA"�}��n}�9��X��ucK�^_u�d��MJ��]h��}���C �FROS�T�`�E�<L���K�T��l��TP�L����OvV�X*�F��������bW���n���+�ڏ��k5b!�#m>Ϣu����	3GY��� KK����r������U#��Ю�qI��h��{ɀll]m���ѱ��eu�,������\���+���c��j�2l��m�7@$]�5�U���G��@�]�Tz�O�.ʂ)%Pbr��i�Xo�һzw��{����C��.(c�C����x���'���4��.E.��o�������\����q�׿�3`�hS��|A�hBc����i��&�Y���h��)�B��/����������2:��������q;����j��7��B�Y~̡4�u���Ԫ��xç�_^~�v5\yʅ�%�qy#Ke��r�̓�ɗ�1��﮲���$�K�+�������K����F���P�L*!)��0F��ԕ2!�T�"�h��!�v.�gw����o4���s�rz���bu1��1�k	.3t���c  �hK���Yܬ�Y��V��+�1���Ć��E�� �(��ȸB�`���	��6dw��S�]�����ɢwi%�|�����~N����"������B��PZ�`�iUy��.o):�'~E�-pK#�%�+(�Sq�����p=�Հ���h�<��������0��m��w�W����Ģ�e��� ��ʪFɲ�BNH�����z~l�C0������w�˲����yZDծ� ��J7���0��p�[n������w����*����ޮ��:��@��������_G�ݢ�ә�!m4a��a ���I9�C�� �$!�B��r5Ê^C�
�p��s�eiE�xS<�ڄxN�3;*�|��)���_��@����5_���x�j�.E,��59����>}Lo��ћq^���=}��;�s�n;��K�=ʖ"���v)b���-�Y������Q#�>���	�$�S6��j���� xqH�a�H��uԒ	������o��i�V2�6&0mcE���ЎS�:����g r�y[#�82��?������~R΋�<��"KK����(����;̕��#��\���~�����?6^��N��b.ª��Wu������NsZ��va*��ƍW ��6��Q!t׶='�=�d���V�ĎP=ӕ5��\v�=vIT���%1�~�=m�Qt�a�hL-j�z�Y���/˳�M-�1J�eQ��kG�|e�������L�N3�4U��t�/J0z��{:�3TM9ٗ�q����`��u]%��U&��}W����T��1ɪ�]i��a�ۑ�������j׍�l��֮�F�C���_V�������<���޶l�>��RN�*�hf������5��}U����>?ʎn읯\�@�g�d��id)�f�A]�����޽O��2Dւs�0���n�u��gwf�j�%:�l�C�=X�eE7�nR�w=8�����x�� Q�ei�t`��U��,�v�+�3�7�P�`��`i)�+&v�j�*���"���=�|�h]�=�4X�k�rV��<��J�ܣ=����W \3�QÌT��q�O�9L���uո�L3t�!s�b��N�^���0-y+$��t9�=�G��(�m�Q���q(�%�Y�Bש{���ėz�*tg��2�N��Rd��_%���c*�#b�r`���s�7�ڎ��]���0�ϔ>��4�F��WC�|����:��e��ty�^O'�7-������΢�ĝ�RŅ!ɻ�gE��@�,�n&{��(V�/g���������m�]�b�K�t��৑������"�E�����~�G��-H\�r��l�\��r�7�.�����V�|������?����ʓ}��3.�"��}��o�@G�a�@��g�`����s���^T~L�X�������`O0]��N����q�VĲ�H�!�_�w�.�cc���v̋��׿�i�E�7��)�ݚ����1��j'2��?p��~�^�[�(C�[X|��"N}h�Tt��I��N�c#��"�e�si5�G��Gf��*��{y�Zb���-��ae��j��h,.�L��ڧm�$�H���f��xPz��x�������27΋ۙ!X����hxZb�j�j��l�Z{�/޺SȚ $�ۅ�$�������}��h_�	?�`et.�uֈ�k�C�e0��v��%9xx>�Ԭ��&�H���%4�IĂ�
�xA���*�,<���������e�VΣO�Tb�|cW;@FAb�����'���-�K������｟ٓ�fg��l��<UC������#�瞴�Ҥ��&�PV�L�7E�l�t���\0�D��	6����4z��2�)�-���UJg��Z~���}�UZ_P����#]N�l<R�QK��*�(�w�6J���r6J��V�T�r���ק7�:#�'    �)]|H]IX��)���e[z�pR�9��ݼ�Ϸc�mKA���?ӕX�/,PT�ۇ�PӪg���J�ms�����,��w9vL����D_�q^;������P���
�N���J�
]6^6�8�s)]��
&,����WՑ���T�f�A_rA�]Mvޣ�����^��kJh?0Z���{cۇ����8�wA���#�����ǋr��
d=�d)W�s�䣋��7S��S����9�~ġ\l�$�WV���G9̟ZYS�OtQB��vcl1KbxE#a�ҥ��QU:Ȼ��uګGg�*r�jm�ǎ��Ƶ�B�����n�C��7`Z׈��t�����꩒�
:IHj��No&$6����9�C�oip���rD(�sʗ����s��\��y�ldSS�jGy�	�Y��%D���So�eK���ﱚu�⽬��u+���t ��J�<Q����Mb�% �[���N#��� r����f�]#M�<�C��ȑ�b8ʃ�v�b=E��Ї��!-Κw�U)��y�����{v��e��)KN��1<�;[4�Dm�Kfwp(��w�wu�ٛ\���_�ψ� W�я���=
f%/y�`�����W���l�~� ��A���cB�	@�p�C��� ĩ����cK�����g����lG��YTw\�3�mo{���S�U�� J=��4��F�c�7zWtĘh � ,b]r���*�$T��[@�,E,w�:���죛5�
G_�n��=���d7'�m�R����/ؼ���(zz딋1��.h)�!�ףW��=P���6����6"�?X��(,·�Y����j��^&JUpk2���ղN�:����K��A�K�n�ҧ�h��*\[�j��~��&O��-X-P�J��aK�b�dˡ<��й�_���~.v�����η>m�h;��^�����f��m�<���Z"/��e�e��i���衑8D��x+��`o����I��7p9�G7/)�(����V��\��SE����0���/�.u���!��+;q��N�>ܮ�gˈE/Y`����0�����A����1�6E�+by|�#�������a��>t���MKKۍ���7�S6:O��r�n����Dޭ�����C�����B�v*��8�hƤ>:ƪ���o�Q������]�K��M�\�q�۟��:A�<��N��nPV[}�Ahoe0π�D�L�{绛��}��E�a �X}@8�p]��ز��>Y�X��2����p7y�rk9=v��hhJ�$]��vrxA9��Ƈr�r�����%h��y�<`#6Ϝ�y�`���) 6��|yzAǇu�5���9�(�l�:�<������U���������bP&�����j�"X�K����-%�,x���l�FNzWM��+�B5���&5���w��k�y9Ȁ�R�����3�J����աo���?��t�1��9t�$^�G�`.�8�WtE��2��^�<ֻ�+�C�
�#�����n݉ݘ���j��-��N��ۢ�ri^�O_;�����F��#���6?�k������ۺ��f�,�FO��
!@��dY�-����H 1~��]��W������^�*#���^}�� ��\����w:�eT���ć��z��N�4;X����C���+={���t�X���.9<y���MM	�ʘ������ҳv��̥�3�M�9\�)�Rd���I�H��,RiKv}%�Cއk�s���W��*�	Z�A�j�e5���q��ԙn�"���ӿ$�zkj/�y|u��>2����[Y�tDL�r^�j�ZJ	B't.m��HL�ֽ�f#T�@CVJ:ٴ�%m���IZ�iG�+ =�qω�+0ϑ����v2T��K��NM�ꠏ�9PD�՚��!�z<K��}9�k�D���1�7+ƲQ�A�CQ$$�k�[�f6��A;�d��J[����PG�#���(��t�NK���>=<5(��DIG�"En���ڷ"�ͪ���S0�*O�KU���KZ��vnp�@y��^܇OPV���C��Yt�f�EM���n�d��g�����^4G��f&�+%���F�s�E�Z$̙��O���"���0��W[Г{�y�G�>��e���<m��J����U.���z�1N�4:R ���Fۢ{��6oN)�i��5��ه㣻��f#���IMe��~JB����_��Zy��0��O���
��O�-��MYfg��g�aV4tTL=f^��`��i�4K���)����:!%����{�c�T�3�_����Z�ZO8��C�QPg|�ʁ%��N��ױ�\?��JFܠ�6�Z�����e�{�z�$[%~���a�霂E��1�������,>\����p:J/�X~G�`��Q�����!uN����:ꆓ�<#o��,ω;/~e�'���wO4�9J�siKݾ�~�\�	�hڞ;Y�ͥ%�vH�]B�#�92>ȭc�֎Q��>��k���1�������=��?_Fl 61��5�ڹ�����P��������������n��+�/U
�ɢ�^��1԰��Pu-�:��#S�鲏a��t������>y8A2���1z_�M��ꠀ��f�P��Qؘ��/z�Uo�b��N�1r?�G,�AL(��v|v�[Y&���,6v�-��!�r/>Ȁ����K��p�6�]ݎjq�
�zZ ��s���j����
6�@�3!o��6	'�;&��6���Y4M �0,k�F��̑�^�>;]�f��QD�����(��r/�"�k��IN�R�z'Wk�*X��4�Q�'ep�Z�����6����s�`/��&0�h��2�����$Y��O���a5�P�dQ�ޕhZ��� � �Y��R�#���sv�mq��4>aa����do�(��f��%�uznwl����9��B!dM�!riM��<���W5��|m�LοQ�B�����"/0 jca�鲳s2�i�N���벍�G��s�
 j��r�{r@�a����#v:r�gT��۵���I.7�7�o��d9���G�Û���/l��)���=Ao�w��T�K'�ⰿ2�����G�����"�)��m	��ϔ��MS\�ڧ����G�&c+��S��z�Z�t2(��:j���m�3`i*0`h5\��@�Zwi�)-�y
%���n5/���{qe�����8��o�A��ٰ���Tr:"-9l��|2R�U��ۏe
-PHGC�_��(�8C����BAneM7?:�����p}d��Q�����%����eA5�裍\Ǒ�t�W����k�����QxQBZ��3$Bhp�n��צ�Nd�1ݝtԯ���j��\[�cuT�� �����%%����Ќ�]��ؑ�Kg[�?�ϭ׻M�i+x����{�獮r�D������K��Fwi�K[z�s�:��⡸��y��W;� nK�) =�����_���s:��x�C��ޙ���n�Ɍ���v`i�!Ü�3�:5g��F6	q��}�EM >o�ݷ�{�m��,�A'a�v�z�����k�:��l�YG2I�"`cHWH��݋Y�a�֣{t�b�*s8�%��b�a�TB���	������i̙FK���������i(d���Q�k����ȷQ~*!�T�-!��K[�wȅ�y�l0S���3{�����|��?��u:�tҧ��R{�6�XÒ?�����q�hp�t��ׯ�����L�B�ՙp���Dj��5f[Y�ؔu�v�{F��{>�~��Q��s�~��t���!���[i��Me��!3����������߈� �}����E� ��|�Fo5�8�#mY�[�n�kw��i�'G�Q�i��b�=;�~�u�M��
Y	z�P!�'�ee̬�D��{[��ჹNa��u��nN	=�F�	�_(Z� �?*lA�ծ���������+���1��A��B�kc�d�/-��8,��}���]���'ң=���m!x� `	  %*�|6�8�O�(w;�a�Q�AN��e����ݍ*��Ңʶ����I!��h�����}U�t�$n�ע��6)�5C��2�R6��q�5s����N��yi^d���E&��m��Y�g`�6)X���*E���;��\o-o��VY,`J���`�c.���Z�[�Z�J�)[�Q���о�V�K,�K��m�P�I�b\�hY�u��9z�l��fLa,�G��`6�󏪆��_��=���4L�[ o����O�'?�3�����[�w���ۮ��*�@�m]�#`V�ܳ^u��;w��aʂoʸ�����$)q���Z ;���S��g�blL�����֠ߕ�S
;*k���{7۽����+^��$tFR_�tH(gl�Q����F�Ja��u�r ^�x?�տ�2S�)}�{[�����,,G�3ϦC�x;�$6eaM~�th���\��b���7eq6�˨��A?x����
���?'C�K���D�魯&w�2����3EY�V��AN�I�b,�ps��ﾦ�yܻ�^RԵ�c�As�V�~�����E���K{�x� %L���eIo�IRM���r��NC�F���|�{���_���*�h�=��ǀf�'�ue{si��1���|�y�.��B}�ep�Ѝ�|���
G�oGq�ʘe?�o����g���RI�)�mS3���L��,%1+��.� a���	�4����5$z6��9�� o0i݉�3����t��1'L�-�O8sה$h�����N��e�c�_�B�7l�LU�i��Y�s��kҶ��oS[��-�Zc2�K����լ��KiR&�W���_�t�i��r�Yysw��*ߠ����Kx˽�����l4SH�5��Vs߀0J��)khUBq�����eҰ�X�#.���W�2�8�����^�J�9��m?���N���u��=e7`�XW@ä�S�ۑ^���i�s��U�ݩp�I*m���������yyL/��*������?��޶��(� �l��*h��؂M���	��:�1�;�=R:�tۧ����њl���!X��m�g��æ�pң
�r0Z��]8h�c>���W��~��ͣW���\�D��ҥo�Vo�|��ȫTRb?%ާ~QJ��j&�.���&��)̟�R�'{�N��'&��ʢ`۔�J6���	.ti{8�vY��qh����D�d^�-����y�4,�*��!���2�jF�
o6����g���+Ng岨����]�=&�iw��e�@x�с���Ǫ���MB?��>FNb8��*j�B��WS��I�L��S6[�ܫI�x��Y�I�x�q��2Q�����m��iA�mD�Ka)�.^�1�wţ�`�����Z�}t�w�e�U��>��X�`��}֞��{S#�_��Xn�Lj[���,���\$��՝=�fq�Q5�gAX��h��f>�Y,,�fѣ�uK��b��Iv�lu�EϷ� K��<��W_���`<"�ـQ�v�ֆ&���YX�yp��llWU}+7w���wJ��6l�'.AqqF�����e~"���
����>%����b�0X,;����zt_�E�-E0|�P��.��r��l���(��,��V���^^(�:R*�IN�Q3�Co��L�?�M�q�68-�U*�pxz%�����f�9�3Y<���?w�����M;fc�"����fWI��&�����0�lRehl"3��Pw�q�!yCTK�"6	�o璛e���M
����n���/s�Rƞ�|�ǧ�:�L_�J&co�"1X�Y��6?��;`5$�Ś�?P�A��8aV"Yᶶ�eMr�ܩ���4����٫-�H�� e�=jZQ�M]�%�FS��?����~�0�腾�˄D�'A�^�4��O��+��jg2dp�UF4�@���L�wN�Mg5%�նP�Km�Y � �͔L!%+\G|<��.V�$��UV%֗���t�����<�x����"�d��0��e*Z��@�7f����q{�|�؀�T�. p�;����k����oIrd8���Z��D+ְ��o�h��(��������6������5�J3%��V��T^�K�p�*��~�ż��Q��f&�һ��2��E�6�:��jb��C�@�D�w=�s����lf��#K0�Z����O�!�9��z�mS`�
���
�E� ��E�	�cn��<���]]�d����=H)��[�>��zL���1�D�w�%�sz?_�{��IL���d^��^m���r�e�x`�����|��s�G���)��!�G��
|�,a�'�T$�޷�Qe��d�<������0]�����Z����]�      4      x�5�Y�,I
�#��;p���9Z���yTl�8ƒ�;��=����o��k�U�����zy�Y��7��7���/N�;���{ߺ�V���ߜ;*ߙ�_�Y�����/޸������{��ۿ9�}�5��"�Z<�#~�U�S{�����9㞼�y�7*��9H,$NU�T�oe�ݑ�~3�{^nؼ��p���5���Z��ܿ5�{�|lo��Zߍ���������6��*�q��9tR��1������㡻_�xu�\���ܬ{�*4^_��Y5���&�{�18��q03�����gK�s��Ջ�z��:c�x��7k��Pr���6JY~�;�K��a��]��Tc�v}g�[/�wXˈ�8c�ߙ_�'c���ٗO���wJ=<w�9'j��;��{�da��pF;^��=G��56��9�r0��a-�U����G�N�ߝ_��;�Z�w�ǚ8����N/�Es�|��W�@b-k�S^�����=�쏃e	�����t����n������Z�(�=��&~F䚿��ڜV�[��4Q�oB:x �˲'w�����[������}��qF�[d��X��Q�Z���9ᯁ� ����� Gpg`/(p���c{*o,��8z�����/���>��~�x�,��~�"��`�=�]c�����/�X��ħ��,���˷p]<'Y��"��%g�oz��������\C/��
P�K��1 >���j=ԋ�/�{*�����q�3�xb�q�<4���ҲXv��g�5&��:\�;_�a]����]Ρ�][�*>���7�P��zXo�C(d� 9�:�xoE� ��Kv�\	�d���c�*�s��̂8ჺ�W/��c�Ʊ�;���g%�a��U��P�*�PC�1<qn
��e�+�	
o"2N5���y���������ť؃�G����@�c�T^-��r�B���*X|o��A��)����Ͻ1i<�<n<��1&A�ٰ�"Ad ���.;"PǠ��6ҩ����p��F+��<'�| �v�"����m�Z��H�K�C���BŚ��W�+E�b��r� g��翽Q�$8��ԥ��XQ�ϰY ����C�������=�Ék*`4�?e��t����IP��m�\�0��8�8����ޜl0G�U����O�&,��2�7�����>��Y��)��� "���q����9�ITm�@�c��(�x���9 � CN81����,vh���1��l�6ʆ�W�i1>�n�8��7?����N^
#�j��r�ݠJ �U�ݚ=Q�B��=��!�=�M�φȀ��"f �+QY[@��N`)nG��b�@8������%�ؚ( �T:�����U��˘�4}'*��T6\i���"�"x%�w �W��YD$��຅+��WS�W�*B	�l��Ϝ��0�&�s�5�R�@����AmH�d?�/1i�Ձ�!cv*��+�\bR|T'~��(��\b;�p�˚a$�� J�0���a!����
�:t+���e��2��8/pQ��E9���( �(7a����]�Z���F>�����Ї�/ƃbyHցZA/o���p�A��i)Pl9,>�%��AQ��Mq8��2�vQ �k!�Q�sA��l�a`;����x�:;����*P�0�7DVU�����>�q!z�PQ���0�ɰo�#��,���	���dK���[�E6�v��G8>���!�cK?��>���C����B�>�x���/X9���nn�v6���3�7�l)��LP���y"�� ��DNЭj���������
Ȏ CDW�Ms�ς�0��*����/J��	�䕘F��,�a���U�!�|c�� 9�J��	�j�a~����DY�=��ծ��<�����K��c�D:�ͦK�76Q9n��!��8���?�����*N��a�aJ��v�s`��Z�
g�^���O�0�~=�aF��G{�����Bt@DW�Ti(����x�)���5	�siHq	 ׯq��oHl��U(l��8.2�+�SW����SY0�,�:����v�k�d��ls!�J�	ʲ/b��5���P8]l�5�У1H��ZM��%K�%>���%���2��O�4��%Q�0%[2uE�柈�N�?#���@�j]_��RQ~�W$|���4��!�d��)ց�$�N�<@����v��i�v�cP*2T{��L���e`���A3S����z�/�Epr�a�ǛaN07�J~�]a���0�Yj�l�UB"M����W��5�)� 7���.4�9��x�FR>\��).�����07�"LF�����v�<�ϛ����q,�(CnK�~����#�,"'8H��2K`�!�xye}䛤��WD݁Ht>�l�����G4���"�q�DZK]a����C�v�w��2�(j<a�,r�� O��E!�]D2��Y����
l'��LA�	\o����-��c�
Q@ll��۟�6>���]AQf ��P?�U���@�mH�9����Vg���~�j���M3�����n�A}����d�%a+^S-C�� 1"jpB��0\M��%�l�zP����q��kS��{8m�6�s*^W��~pg��,n�V$:/�_��jva2��������<EV�=�[}����a�����'(��Hba��K���^�3/8:��l"���.�v����fR|1L����YU׃0vll/��N�a�~m��`��+��ü�������hkb;>2����x$�ۄ��|P�.ֹ*�<�a� �\mX: ��I�����(��X�A��5	�s�������g��]�,sbj,2]��C�a��Z������'�^�����>�+;�rgpf�g��)�/���!ܹ���f��_�Za%TY���`;1\d�
lG�]�$<a]��ײxr~��x-���5(�7���2˒��M2�+1�5�E��� �+�U���Ik2�mr�d0 ��Glo�(qO�lj��h@@?�I�J�l��d�`�۹�O���C�I���"9���.���H>��I(�Yy�֨����M`QlX �m���s��-E<�U>���'�1��δ��Z�����4��4��I�p|�U���1��*��b���ဋ���I:�NF$:�3i��W�_����oMfZ�$��?9�.�K� 
�Yl�)E,�� �b֠��]��zF`�Y
$�+K5Ղ���؎N�@1�9�#WLK�3c�`{�Ԕ`���vT@�3�G�k gP4���X��c�<��C]qgH	Y������v��
�RL�%�5��f�hX1�њh�a���c��$O�e%�Y�A���_�|����14���wChDDW�T�pÛ�3�T��C�V?��Z7-�c� ��-���OQWb��P ����`��Y��B�&�'xD+�,�Pw7<�dXF_�!��Xk��Q��p���DB�W�	#r�'D����Z�(4,D��o�%v�vR!��	i��-t��c��\���΀/d�g�f('��^��:]����x�j��fGV��$.[�ۃ�h��#어�0F�l�����>�5	�,o��gnQlgo ��U�]E�jn�����(˕3��2�v��%�D*��#U��_"v��ʪQ��e`��A���	���tM��&�#��-Ȕ�`���U�sZ�!`#�++�����օ��+o�Æyյ�N�&J[�!`[S���k�}X��&!Z듘�u���%���rQ �֗7g�r]�5���e��Y?y	a�EĮ���Ѡ�D)@&�)]�v���Y0=�c+�3�!�iԷt!�4��Y��5K���|6����-D��a�U-�Y�-�H��A)��۠�v,0�{9A\�k��l�f�xʕ��J`��* ;  tu�e]��Wގa��_E�ᒐ=�PW�����7���15�8��u�ĵjl�]M�w{����sG�d��$��nm��N�5�M`v#�����!9�r�k4fA�5��Ӫ0뚭�A�Α���Rڸ�Y��h�6KaWl�����5��a�A�$3c0���d<��)�s�����v��*�bW���ma��7�N���EZo�hY�р��]C�vӱv�|V~�ݚؼl��-� jWæ��>����j��fDT<x��� I��v��!e�Y��p��]�+oK��fV���� 0D�Js'�3�����m��O�
�FP����6�9AK���G�[jG���;l���l#۷�m��;�;��o�;����nw"��ȹ�gO,�Wɯ�=ֲ8������v�8y{�hl稳3k����u���v[/؛,og�4GDW� �^�킈�k��/�Hڠ��vrY�gd�=�}�BŔ�ې�~Uu[�*ұ�=lI�N';ͼ��c���Y)�U_�W{7KGdU���қ�Rm���S��<�6+Y���>X��,D8ny;@~�f�ߓ��hvF�"�y�!�1y�L�:"9δ���F�e�D��M.P�WYU��=�@lh�,;��l7���7`/�6$����N&! �fy;n@�d�V?8�WY���ː��vL �L�:Ӳ��ٽ#�ݚ/�*0�he�b��1D�jX�2���u���?��������ɖ��fOp9?[�ֿ����%e֚��_����������C=��(�n�|֮�r�h]���<�et�\Y���6w���Yo��4�L=�=T��2���8K��j!߀�k�]��N~�	[�BV0'�"�D�+�Vëe��d}h�*`{llk�D�듷��8���vk�VO;�pȉ��غ¬P�7?KaЇm��BY3˲}���MF�))Pa����#\�L,�z�]8��U]�~^=*�����a}���|־�&:̼�#K�
g�/��\������(��2^,��B?�Ҧ�۫;�N=��?�Y�U���ϖN���>\�V�om��a���/~^���S�SLS��p�bU`�K+�-l���
	������;&��y�7;�v��3
{^���"�v\���`V��ϱ2�;�����������v�hߙ�b�6�M+���T�W.�]zU�"��d���^*.��z�f�w��nM�L�YoOkY���2�nF����g�����f�=P�8V��m�����,�Y<k�]>9��l��`-9���������G*G��d�y�� �W���}��iA؉��v��"��L�R�LZ��*��]���D4�3�� ���5X�W�C�0��%�,����^���`4���Y�Al]-�7���^�][�L^嬢<�t�v�$����1${h��]�i���N��`��N�3�a���_���22|��>���ϖd�l��?K���*��0M�&G}zx'�v'���ܕm눤̈�����o��2�ۇ4vX�y;�b�Y�%e��/�v�[g���v��Qv�?+�Vo9���Nn���!����ἰ�n	��Bގ.l^iM��N����&��B/ȫ�3t�]B��nM���^*/¿��Ʊ�lMF��Vk��&!ꃭ���t��qo�Rt�9b�C�[���]�KZ���Z��m4��+6) ��̞�={�`���&�]k2�Q�5fO) Z�z��zb�|� ��Ca��0q�C������~���W|诗Z��
��E�c]���d�$���[ow,���L���	!!�!v]�� ��� ��uy�q^���殷Gw��Xp��Dg]Cl�p�����s����,�V�nO��fy;!D�@C�Pv�l��<� �D+E�^�i8'�$�PLߜ�m�����H�������/���4���qiyNXo'y�c:Gyl� "��!����gr�Aq2�{ܶ0Ì |�O�g]��`V-����Ȫ��Ȝ}	�'G�l�������TG��U�RM<Y�94k��^V���Px�g3ȼd�!|pY6tx�8ȵZ��Rl?Nj��2\��,2���ۇ/�ӆ���B�3���ix'���QS���[��m���XR&��ۻ3�h�]�
�& i/�,�ױȩb���L{��j��:qm�N�W���k��l��!�B�C�ʷՕ��3�H{�v�0� & ۇ���K�]�,�ttv:zo���F���r��Kk2օ\��m�Y��`�r6�:ʕ�v��oq>��ak�PRD+���,e2�>�Hټ���7;��?�wF��޾�mO� i/���:m��t�PU�z����Z�]o7����u��h��Ni/�kq�?�Ŗ>�&��θ-SBD�-%�b�pX�	��7ݗu�X�΄-)��nI��5 ��KX0LD{�dO6M�����0PW��������RM��W�v�C�j`��GVU]���l�!Q���I;�f��_c�� ��V��qE�+�� :������=���ъ�n�j�K�KԱ���)��c	�}�.��m�i�]��P/���Ƙ��Z;vN Z5X��kM&�_�qb�E�d��L�ߜ�!����1�r��5Gg^V���;/�ٷ����!w_u��[N��۟�]RĴ&c��N�ov�8���T�sZ�O_l/s�.��L�Q��щ�e;�����xF��a��ޢc���c�C(p��]�ū�檾 �ۖ\]��4:x� ��M��ԅo|Nȱ0��i�袸^Vq�)ͼ Ug�Е�>$�6T���ܫ �1�'TmW��l*�o!���С	�Y{��h�6z��'�)��`��Uq�ǚ�A�������+��|�lĨ�#����_шs%���)K[���15ó����ٜ�ص>�؆��2٘r����X=�k��N��f�YjͿ�W7�`�q��E�����/��=;U`÷쥢wh�w�����]?�尥��Aa���;����f+EXN�����#������/��Xη�hƊ:�c��<�뒷W�,M����;r
η��&v �u-��HE�E/��{�����N_��"�w[���8ͬ�H�j����i�e�h�V�V#�fS`Yb�|���
�m��3��^��p(�v|j��Q�ɨ���Uڇ�GR�ؕt��!�WG��߲���,'Kl�����u�U�/3��9�ǚ����'�Ͱ>�S&���=zC![FDW�*��D4K-�������UO�z��t@��v'em�Bհe�����(��*��*���ˎ7b㕭���{���,�	D��V�Vլ��|st����kv�8���+ؤ�͇��	�X�^B��AH4%�4��m��[���RR쮥&�g$�w9ޙuĮ�y�-��%�(E����8�.�R�����m�Id���	j7�@�Y5aџ*�A�jm��&�����":m��Uk�����i(�p�qJ/ ����Vl0;K�dɿ�ο�!�E�&4�Gt���#��[��0�#:ea5�C�Cb��l�N�Q���y�Ulk�f��wNƖ&_s��s����]�`���R0��~�����d     