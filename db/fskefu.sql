CREATE TABLE public.cc_agent
(
  agent_no character varying(50) NOT NULL, -- 工号，即座席号
  agent_name character varying(50), -- 座席名称
  agent_pass character varying(50), -- 座席密码
  agent_externsion character varying(30), -- 对应的分机号
  login_time timestamp without time zone DEFAULT now(), -- 登入时间
  actived boolean DEFAULT true,
  is_say_job_number boolean DEFAULT false, -- 是不是要报工号
  is_cs boolean DEFAULT true, -- 是否进行评价，满意度评价，标准的，满意0，一般1，不满意2
  id uuid,
  CONSTRAINT "PKG_AGENT_NO" PRIMARY KEY (agent_no)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_agent
  OWNER TO postgres;
COMMENT ON COLUMN public.cc_agent.agent_no IS '工号，即座席号';
COMMENT ON COLUMN public.cc_agent.agent_name IS '座席名称';
COMMENT ON COLUMN public.cc_agent.agent_pass IS '座席密码';
COMMENT ON COLUMN public.cc_agent.agent_externsion IS '对应的分机号';
COMMENT ON COLUMN public.cc_agent.login_time IS '登入时间';
COMMENT ON COLUMN public.cc_agent.is_say_job_number IS '是不是要报工号';
COMMENT ON COLUMN public.cc_agent.is_cs IS '是否进行评价，满意度评价，标准的，满意0，一般1，不满意2';


-- Index: public."IDX_CC_AGENT_LOGIN_TIME"

-- DROP INDEX public."IDX_CC_AGENT_LOGIN_TIME";

CREATE INDEX "IDX_CC_AGENT_LOGIN_TIME"
  ON public.cc_agent
  USING btree
  (agent_no COLLATE pg_catalog."default", login_time, agent_externsion COLLATE pg_catalog."default");
  

CREATE TABLE public.cc_agent_cases
(
  id uuid NOT NULL,
  account_id character varying(36),
  case_id character varying(36),
  date_modified timestamp(6) without time zone,
  deleted smallint,
  CONSTRAINT pk_accounts_case_key PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_agent_cases
  OWNER TO postgres;
COMMENT ON TABLE public.cc_agent_cases
  IS '作为座席与事件的关联';


CREATE TABLE public.cc_agent_contacts
(
  id uuid NOT NULL,
  contact_id character varying(36),
  account_id character varying(36),
  date_modified timestamp(6) without time zone,
  deleted smallint,
  CONSTRAINT pk_accounts_contacts_key PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_agent_contacts
  OWNER TO postgres;
COMMENT ON TABLE public.cc_agent_contacts
  IS '座席与联系人的关联表';


CREATE TABLE public.cc_agent_group
(
  id bigint NOT NULL DEFAULT nextval('cc_agent_group_id_seq'::regclass),
  group_name character varying(50)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_agent_group
  OWNER TO postgres;

  
CREATE TABLE public.cc_agent_group_map
(
  id bigint NOT NULL DEFAULT nextval('cc_agent_group_map_id_seq'::regclass),
  agent_group_id bigint,
  agent_id bigint
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_agent_group_map
  OWNER TO postgres;
  
CREATE TABLE public.cc_agent_history
(
  id bigint NOT NULL DEFAULT nextval('cc_agent_history_id_seq'::regclass),
  agent_no character varying(50),
  agent_externsion character varying(30),
  login_time timestamp without time zone,
  logout_time timestamp without time zone
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_agent_history
  OWNER TO postgres;
  
CREATE TABLE public.cc_cases
(
  id uuid NOT NULL,
  name character varying(255),
  access_number character varying(30),
  date_entered timestamp(6) without time zone,
  date_modified timestamp(6) without time zone,
  modified_user_id character(36),
  created_by character(36),
  description text,
  deleted smallint,
  assigned_user_id character(36),
  case_number integer NOT NULL,
  type character varying(255),
  status character varying(25),
  priority character varying(25),
  resolution text,
  work_log text,
  agent_id character(36),
  product_id character varying(36), -- 商品id
  CONSTRAINT pk_cases_key PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_cases
  OWNER TO postgres;
COMMENT ON TABLE public.cc_cases
  IS '事件表，关联座席和联系人';
COMMENT ON COLUMN public.cc_cases.product_id IS '商品id';


CREATE TABLE public.cc_contacts
(
  id uuid NOT NULL,
  access_number character varying(30),
  date_entered timestamp(6) without time zone,
  date_modified timestamp(6) without time zone,
  modified_user_id character(36),
  created_by character(36),
  description text,
  deleted smallint,
  assigned_user_id character(36),
  salutation character varying(5),
  first_name character varying(100),
  last_name character varying(100),
  title character varying(100),
  department character varying(255),
  do_not_call smallint,
  phone_home character varying(25),
  phone_mobile character varying(25),
  phone_work character varying(25),
  phone_other character varying(25),
  phone_fax character varying(25),
  primary_address_street character varying(150),
  primary_address_city character varying(100),
  primary_address_state character varying(100),
  primary_address_postalcode character varying(20),
  primary_address_country character varying(255),
  alt_address_street character varying(150),
  alt_address_city character varying(100),
  alt_address_state character varying(100),
  alt_address_postalcode character varying(20),
  alt_address_country character varying(255),
  assistant character varying(75),
  assistant_phone character varying(25),
  lead_source character varying(100),
  reports_to_id character(36),
  birthdate date,
  campaign_id character(36),
  call_total integer DEFAULT 0,
  CONSTRAINT pk_contacts_key PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_contacts
  OWNER TO postgres;
COMMENT ON TABLE public.cc_contacts
  IS '联系人表';

CREATE TABLE public.cc_contacts_cases
(
  id uuid NOT NULL,
  contact_id character varying(36),
  case_id character varying(36),
  contact_role character varying(50),
  date_modified timestamp(6) without time zone,
  deleted smallint,
  CONSTRAINT pk_contacts_cases_key PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_contacts_cases
  OWNER TO postgres;
COMMENT ON TABLE public.cc_contacts_cases
  IS '联系人与事件关联';
  
CREATE TABLE public.cc_cs
(
  id bigint NOT NULL DEFAULT nextval('cc_cs_id_seq'::regclass),
  uuid character varying(50), -- 通话的uuid
  agent_no character varying(30), -- 工号
  cs character varying(10), -- 满意度值
  extension_no character varying(30), -- 分机号
  cs_time timestamp without time zone DEFAULT now() -- 评价时间
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_cs
  OWNER TO postgres;
COMMENT ON TABLE public.cc_cs
  IS '满意度调查表';
COMMENT ON COLUMN public.cc_cs.uuid IS '通话的uuid';
COMMENT ON COLUMN public.cc_cs.agent_no IS '工号';
COMMENT ON COLUMN public.cc_cs.cs IS '满意度值';
COMMENT ON COLUMN public.cc_cs.extension_no IS '分机号';
COMMENT ON COLUMN public.cc_cs.cs_time IS '评价时间';


CREATE TABLE public.cc_customer_satisfaction
(
  id bigint NOT NULL DEFAULT nextval('cc_customer_satisfaction_id_seq'::regclass),
  uuid character varying(50),
  src_number character varying(30),
  dest_number character varying(30),
  extension character varying(30),
  keytime timestamp without time zone,
  key character varying(10)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_customer_satisfaction
  OWNER TO postgres;

CREATE TABLE public.cc_product
(
  id uuid,
  p_name character varying(100), -- 商品名称
  p_pc_uuid character varying(36), -- 商品分类标志id
  p_price numeric, -- 商品单价
  p_desc text -- 商品描述
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_product
  OWNER TO postgres;
COMMENT ON COLUMN public.cc_product.p_name IS '商品名称';
COMMENT ON COLUMN public.cc_product.p_pc_uuid IS '商品分类标志id';
COMMENT ON COLUMN public.cc_product.p_price IS '商品单价';
COMMENT ON COLUMN public.cc_product.p_desc IS '商品描述';

CREATE TABLE public.cc_product_category
(
  id uuid,
  pc_name character varying(100), -- 商品种类名称
  pc_group character varying(36), -- 商品种类所属的组，和外呼座席组对应
  pc_desc text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_product_category
  OWNER TO postgres;
COMMENT ON COLUMN public.cc_product_category.pc_name IS '商品种类名称';
COMMENT ON COLUMN public.cc_product_category.pc_group IS '商品种类所属的组，和外呼座席组对应';