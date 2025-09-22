--
-- PostgreSQL database dump
--

\restrict nHPHgJklSKANp2sninrGF2QGEpLCvJUfsmxeqs9b9SDuXhN3k8RcXRYbbDA8QsR

-- Dumped from database version 17.4 (Debian 17.4-1.pgdg120+2)
-- Dumped by pg_dump version 17.6

-- Started on 2025-09-22 01:03:11 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3403 (class 0 OID 16515)
-- Dependencies: 236
-- Data for Name: auction_item; Type: TABLE DATA; Schema: public; Owner: db_user
--

COPY public.auction_item (id, item_id, name, name_key, category, color) FROM stdin;
1	9mmq	Мякоть солевика	item.misc.saltweed.name	medicine	DEFAULT
2	1ddr	Мякоть мятноплода	item.misc.mintfruit.name	medicine	RANK_NEWBIE
3	g00n	Мякоть сластены	item.misc.sweettooth.name	medicine	RANK_STALKER
4	z77k	Мякоть спиртня	item.misc.alcohol.name	medicine	RANK_VETERAN
5	5ddo	Мякоть куборбуза	item.misc.cubemelon.name	medicine	RANK_MASTER
6	y770	Мякоть лимонника	item.misc.lemonfruit.name	medicine	RANK_LEGEND
7	wooz	Тусклые минералы	item.misc.dimmer_minerals.name	misc	DEFAULT
8	400j	Изумрудные минералы	item.misc.emerald_minerals.name	misc	RANK_NEWBIE
9	kllj	Лазурные минералы	item.misc.azure_minerals.name	misc	RANK_STALKER
10	qvv4	Пурпурные минералы	item.misc.purple_minerals.name	misc	RANK_VETERAN
11	jlll	Алые минералы	item.misc.scarlet_minerals.name	misc	RANK_MASTER
12	lll2	Золотые минералы	item.misc.golden_minerals.name	misc	RANK_LEGEND
13	rrrz	Бледнолист	item.misc.pale_leaf.name	misc	DEFAULT
14	033k	Кислотная крапива	item.misc.acid_nettle.name	misc	RANK_NEWBIE
15	m22k	Водонос	item.misc.water_carrier.name	misc	RANK_STALKER
16	ovv5	Гнозис	item.misc.gnosis.name	misc	RANK_VETERAN
17	npp9	Чертоцвет	item.misc.hellroot.name	misc	RANK_MASTER
18	prrd	Янтарная полынь	item.misc.amber_wormwood.name	misc	RANK_LEGEND
19	g0vn	Канистра с бензином	item.misc.canister_petrol.name	misc	RANK_NEWBIE
20	z7lk	Канистра с дизелем	item.misc.canister_diesel.name	misc	RANK_STALKER
21	5dgo	Баллон с пропаном	item.misc.balon_propane.name	misc	RANK_STALKER
22	y7j0	Баллон с метаном	item.misc.balon_methane.name	misc	RANK_VETERAN
23	wo6z	Адронный конвертор	item.misc.hadron_converter.name	misc	RANK_MASTER
24	401j	Батарея холодного синтеза	item.misc.cold_fusion_battery.name	misc	RANK_MASTER
25	g0gp	Гнилые доски	item.misc.rotten_boards.name	misc	DEFAULT
26	z7pn	Ткань	item.misc.fabric.name	misc	DEFAULT
27	y7po	Реагенты	item.misc.reagents.name	misc	RANK_NEWBIE
28	wopo	Перчатки	item.misc.gloves.name	misc	DEFAULT
29	40vn	Аммиак	item.misc.ammonia.name	misc	DEFAULT
30	klwv	Нефть	item.misc.oil.name	misc	DEFAULT
31	qvrk	Борная кислота	item.misc.boric_acid.name	misc	DEFAULT
32	jl66	Защитное снаряжение	item.misc.protective_gear.name	misc	RANK_NEWBIE
33	ll41	Изолента	item.misc.insulating_tape.name	misc	RANK_NEWBIE
34	rr05	Дрожжи	item.misc.yeast.name	misc	DEFAULT
35	03v1	Колба с раствором	item.misc.solution_flask.name	misc	RANK_STALKER
36	m2k7	Глаз зомби	item.misc.dead_eye.name	misc	RANK_STALKER
37	ovj0	Гипофиз мертвеца	item.misc.dead_hypophysis.name	misc	RANK_MASTER
38	npq3	Аномальная плазма	item.misc.abnormal_plasm.name	misc	RANK_VETERAN
39	prl2	Кофе	item.misc.coffee.name	misc	DEFAULT
40	vrpd	Мясо шавки	item.misc.dog_meat.name	misc	DEFAULT
41	dq0n	Мясо хрюши	item.misc.flesh_meat.name	misc	DEFAULT
42	2d76	Мясо кабана	item.misc.boar_meat.name	misc	DEFAULT
43	3rpg	Полутухлая рыба	item.misc.fish_rotten.name	misc	DEFAULT
44	7rp7	Чеснок	item.misc.garlic.name	misc	DEFAULT
45	6rpy	Помидор	item.misc.tomato.name	misc	DEFAULT
46	1d31	Банка с фасолью	item.misc.beans_box.name	misc	DEFAULT
47	g02p	Банка с горохом	item.misc.peas_box.name	misc	DEFAULT
48	5dp0	Банка с пшеном	item.misc.millet_box.name	misc	DEFAULT
49	y7mo	Банка с макаронами	item.misc.pasta_box.name	misc	RANK_NEWBIE
50	woro	Опухоль мертвеца	item.misc.dead_bladder.name	misc	DEFAULT
51	40pn	Аномальные дрожжи	item.misc.anomal_yeast.name	misc	RANK_NEWBIE
52	kl9v	Молоко	item.misc.milk.name	misc	DEFAULT
53	qvwk	Клей	item.misc.glue.name	misc	DEFAULT
54	jl26	Полимеры	item.misc.polymers.name	misc	RANK_NEWBIE
55	ll11	Сломанный прибор	item.misc.broken_device.name	misc	DEFAULT
56	rr45	Асбест	item.misc.asbestos.name	misc	DEFAULT
57	03p1	Газовый баллон	item.misc.gas_cylinder.name	misc	RANK_NEWBIE
58	m2g7	Текстолит	item.misc.textolite.name	misc	DEFAULT
59	ov50	Сковорода	item.misc.frying_pan.name	misc	DEFAULT
60	npz3	Кастрюля	item.misc.pot.name	misc	DEFAULT
61	pry2	Пластиковая бутылка	item.misc.bottle.name	misc	DEFAULT
62	vrld	Консервная банка	item.misc.tincan.name	misc	DEFAULT
63	dq2n	Мультитул	item.misc.multitool.name	misc	RANK_VETERAN
64	2d56	Набор болтов	item.misc.bolts_kit.name	misc	RANK_MASTER
65	9mr0	Жгут	item.misc.tourniquet.name	misc	RANK_NEWBIE
66	1d56	Щепки	item.misc.chips.name	misc	RANK_NEWBIE
67	g060	Набор для шитья	item.misc.sewing_kit.name	misc	RANK_NEWBIE
68	z7d2	Кислота	item.misc.acid.name	misc	RANK_NEWBIE
69	5dkg	Раствор йода	item.misc.iodine_solution.name	misc	RANK_NEWBIE
70	y7dz	Морозная смесь	item.misc.frosty_mixture.name	misc	RANK_NEWBIE
71	wodp	Электросмесь	item.misc.electric_mixture.name	misc	RANK_NEWBIE
72	404p	Термическая смесь	item.misc.thermic_mixture.name	misc	RANK_NEWBIE
73	kl70	Гипс	item.misc.gypsum.name	misc	RANK_NEWBIE
74	qv76	Нефтяной кокс	item.misc.nef_coke.name	misc	RANK_NEWBIE
75	jl77	Железо	item.misc.iron.name	misc	RANK_NEWBIE
76	ll7j	Белковый субстрат	item.misc.protein_substrate.name	misc	RANK_NEWBIE
77	rr7g	Медь	item.misc.copper.name	misc	RANK_NEWBIE
78	03zd	Амортизирующее покрытие	item.misc.shock_absorbing_coating.name	misc	RANK_NEWBIE
79	m27j	Аминокислота	item.misc.amino_acid.name	misc	RANK_NEWBIE
80	ov7o	Альфа биоматериал	item.misc.strong_mutants_remains.name	misc	RANK_NEWBIE
81	npr6	Цинк	item.misc.zinc.name	misc	RANK_NEWBIE
82	prm6	Свинец	item.misc.lead.name	misc	RANK_NEWBIE
83	vr1n	Плазма крови	item.misc.blood_plasma.name	misc	RANK_NEWBIE
84	dqg5	Животный жир	item.misc.animal_fat.name	misc	RANK_NEWBIE
85	2dq0	Жареное мясо шавки	item.misc.dog_meat_fried.name	food	DEFAULT
86	3r6z	Жареное мясо хрюши	item.misc.flesh_meat_fried.name	food	DEFAULT
87	7rm3	Жареное мясо кабана	item.misc.boar_meat_fried.name	food	DEFAULT
88	6r0j	Мука	item.misc.flour.name	misc	RANK_NEWBIE
89	9mn0	Рыбное филе	item.misc.fish_cut.name	food	DEFAULT
90	1dk6	Набор специй	item.misc.spices.name	misc	RANK_NEWBIE
91	g0y0	Соленья	item.misc.pickles.name	food	DEFAULT
92	z7y2	Протертые овощи	item.misc.vegetables.name	food	DEFAULT
93	5drg	Брага	item.misc.grape_must.name	food	DEFAULT
94	y75z	Сок	item.misc.juice.name	drink	DEFAULT
95	wogp	Доски	item.misc.boards.name	misc	RANK_NEWBIE
96	40lp	Микроэлектроника	item.misc.microelectronics.name	misc	RANK_NEWBIE
97	klq0	Биогаз	item.misc.organic_gases.name	misc	RANK_NEWBIE
98	9mgw	Древесный уголь	item.misc.charcoal.name	misc	RANK_NEWBIE
99	1dnq	Тканевая сумка	item.misc.fabric_bag.name	misc	RANK_NEWBIE
100	g05g	Латунь	item.misc.brass.name	misc	RANK_NEWBIE
101	z719	Сталь	item.misc.steel.name	misc	RANK_NEWBIE
102	5d24	Ртуть	item.misc.mercury.name	misc	RANK_NEWBIE
103	y79w	Медная крошка	item.misc.copper_chips.name	misc	RANK_NEWBIE
104	wo2d	Хлор	item.misc.chlorine.name	misc	RANK_NEWBIE
105	40dl	Водород	item.misc.hydrogen.name	misc	RANK_NEWBIE
106	klk3	Этилен	item.misc.pure_ethylene.name	misc	RANK_NEWBIE
107	qvm9	Азотная кислота	item.misc.nitric_acid.name	misc	RANK_NEWBIE
108	jl44	Серная кислота	item.misc.sulfuric_acid.name	misc	RANK_NEWBIE
109	ll6q	Едкий натрий	item.misc.sodium_hydroxide.name	misc	RANK_NEWBIE
110	035r	Углекислый газ	item.misc.carbon_dioxide.name	misc	RANK_NEWBIE
111	m2lr	Карбоноволокно	item.misc.boron_carbide.name	misc	RANK_NEWBIE
112	ovo4	Абразив	item.misc.silicon_carbide.name	misc	RANK_NEWBIE
113	np0w	Поташ	item.misc.potash.name	misc	RANK_NEWBIE
114	prp5	Очищенный жир	item.misc.purified_fat.name	misc	RANK_NEWBIE
115	vrwg	Сусло	item.misc.mash.name	food	RANK_NEWBIE
116	dqn9	Аномальные материалы	item.misc.anomalous_materials.name	misc	RANK_NEWBIE
117	2dkm	Фарш из собаки	item.misc.dog_meat_ground.name	food	RANK_NEWBIE
118	3rjk	Фарш из хрюши	item.misc.flesh_meat_ground.name	food	RANK_NEWBIE
119	7rvr	Фарш из кабана	item.misc.boar_meat_ground.name	food	RANK_NEWBIE
120	6rn6	Тесто	item.misc.dough.name	misc	RANK_NEWBIE
121	9m7w	Сгущенка	item.misc.condensed_milk.name	food	RANK_NEWBIE
122	1dwq	Базовое вино	item.misc.base_wine.name	drink	RANK_NEWBIE
123	g07g	Тиражный ликер	item.misc.tirage_liqueur.name	drink	RANK_NEWBIE
124	z7m9	Мультимер	item.misc.multimer.name	misc	RANK_NEWBIE
125	5dm4	Контрольная плата	item.misc.controller.name	misc	RANK_NEWBIE
126	y7rw	Детали электромотора	item.misc.motor_parts.name	misc	RANK_STALKER
127	wokd	Смазочные материалы	item.misc.lubricants.name	misc	RANK_STALKER
128	40rl	Разделочная доска	item.misc.cutting_board.name	misc	RANK_NEWBIE
129	99dl	Фреза	item.misc.milling_cutter.name	misc	RANK_STALKER
130	gmn6	Пулевой сплав	item.misc.bullet_alloy.name	misc	RANK_NEWBIE
131	5n51	Порох	item.misc.powder.name	misc	RANK_NEWBIE
132	y24k	Йодид калия	item.misc.potassium_iodide.name	misc	RANK_STALKER
133	w732	Селитра	item.misc.ammonium_nitrate.name	misc	RANK_NEWBIE
134	4nkr	Алюминиевый порошок	item.misc.aluminum_oxide.name	misc	RANK_STALKER
135	km6y	Серная соль	item.misc.sulfur_oxide.name	misc	RANK_STALKER
136	q2yj	Крепкая сталь	item.misc.reinforced_steel.name	misc	RANK_STALKER
137	jon0	Нашатырь	item.misc.ammonium_chloride.name	misc	RANK_STALKER
138	l2kk	Глицерин	item.misc.glycerin.name	misc	RANK_NEWBIE
139	r2mv	Вино с осадком	item.misc.wine_with_sediment.name	drink	RANK_STALKER
140	0279	Автотрансформатор	item.misc.compact_transformer.name	misc	RANK_STALKER
141	mm4y	Продвинутый электрод	item.misc.advanced_electrode.name	misc	RANK_STALKER
142	om46	Набор тонких сверл и бит	item.misc.drillbits.name	misc	RANK_STALKER
143	nmj1	Листы сваренного металла	item.misc.welded_metal.name	misc	RANK_STALKER
144	p3vw	Электродвигатель	item.misc.electric_motor.name	misc	RANK_STALKER
145	z2om	Дымный порох	item.misc.black_powder.name	misc	RANK_STALKER
146	5njq	Алюминий	item.misc.pure_aluminum.name	misc	RANK_STALKER
147	y263	Метан	item.misc.methane.name	misc	RANK_STALKER
148	w7y3	Отбеливатель	item.misc.nitrogen_chloride.name	misc	RANK_STALKER
149	4njo	Хлорид алюминия	item.misc.aluminum_chloride.name	misc	RANK_STALKER
150	km2p	Ацетилхлорид	item.misc.acetyl_chloride.name	misc	RANK_STALKER
151	q2p3	Полипропилен	item.misc.polypropylene.name	misc	RANK_STALKER
152	jowg	Психореагент	item.misc.psychoreagent.name	misc	RANK_STALKER
153	l2oo	Зажигательное покрытие	item.misc.incendiary_coating.name	misc	RANK_STALKER
154	r29y	Гормоны	item.misc.hormones.name	misc	RANK_STALKER
155	026y	Протромбин	item.misc.prothrombin.name	misc	RANK_NEWBIE
156	mmn2	Кровяная сыворотка	item.misc.blood_serum.name	misc	RANK_STALKER
157	om6m	Измерительное оборудование	item.misc.measuring_equipment.name	misc	RANK_VETERAN
158	nmo2	Прочный металл	item.misc.durable_metal.name	misc	RANK_STALKER
159	p3o4	Роторная система	item.misc.rotary_system.name	misc	RANK_STALKER
160	v25p	Операционный усилитель	item.misc.operational_amplifier.name	misc	RANK_STALKER
161	dj92	Набор кухонных ножей	item.misc.kitchen_knives.name	misc	RANK_NEWBIE
162	2nw5	Защитное покрытие	item.misc.protective_cover.name	misc	RANK_STALKER
163	999q	Плитоноска	item.misc.plate_carrier.name	misc	RANK_STALKER
164	gmmn	Гильза	item.misc.sleeve.name	misc	RANK_STALKER
165	z22k	Пуля	item.misc.bullet.name	misc	RANK_STALKER
166	5nno	Крупнокалиберная пуля	item.misc.large_bullet.name	misc	RANK_STALKER
167	y220	Адреналин	item.misc.adrenaline.name	misc	RANK_VETERAN
168	w77z	Этилалюмин	item.misc.aluminum_tritylate.name	misc	RANK_VETERAN
169	4nnj	Гремучая ртуть	item.misc.mercury_fulminate.name	misc	RANK_STALKER
170	kmmj	Промышленный растворитель	item.misc.industrial_solvent.name	misc	RANK_STALKER
171	q224	Нитроглицерин	item.misc.nitroglycerin.name	misc	RANK_STALKER
172	jool	Анилин	item.misc.aniline.name	misc	RANK_VETERAN
173	l222	Антитоксин	item.misc.detoxification_agent.name	misc	RANK_VETERAN
174	r22z	Ноотроп	item.misc.nootrop.name	misc	RANK_VETERAN
175	022k	Сверло	item.misc.drill.name	misc	RANK_VETERAN
176	mmmk	Сосуд реактора	item.misc.reactor_vessel.name	misc	RANK_VETERAN
177	99pz	Полиэтиленовая основа	item.misc.polyethylene_suspension.name	misc	RANK_STALKER
178	1731	Кевлар	item.misc.kevlar.name	misc	RANK_VETERAN
179	gm2p	Нитрожелатин	item.misc.igniting_gelatin.name	misc	RANK_STALKER
180	z29n	Динамит	item.misc.dynamite.name	misc	RANK_STALKER
181	5np0	Мутировавшие ферменты	item.misc.mutated_enzymes.name	misc	RANK_VETERAN
182	y2mo	Нейродегенерант	item.misc.neurodegenerant.name	misc	RANK_VETERAN
183	w7ro	Мутаген	item.misc.mutagen.name	misc	RANK_VETERAN
184	4npn	Теломераза	item.misc.telomerase.name	misc	RANK_VETERAN
185	km9v	Коагулянт	item.misc.coagulant.name	misc	RANK_STALKER
186	q2wk	Воздуховод	item.misc.ventilation_duct.name	misc	RANK_VETERAN
187	99n0	Полиуретан	item.misc.polyurethane.name	misc	RANK_VETERAN
188	17k6	Фермент мутации	item.misc.mutation_essence.name	misc	RANK_MASTER
189	gmy0	Очищающий реагент	item.misc.zeroing_essence.name	misc	RANK_MASTER
190	z2y2	Аномальные гены	item.misc.abnormal_genes.name	misc	RANK_MASTER
191	1jog	Топливный фильтр	go.hideout_generator_fuel_filter.name	other	RANK_STALKER
192	gvk6	Станция для приема баллонов с газом	go.hideout_generator_gas_station.name	other	RANK_STALKER
193	zlky	Инвертор	go.hideout_generator_invertor.name	other	RANK_VETERAN
194	5gy1	Станция для приема батарей	go.hideout_generator_battery_station.name	other	RANK_VETERAN
195	lvrk	Рохля	go.hideout_storage_trolley.name	other	RANK_STALKER
196	rzvv	Водосборник	go.hideout_storage_water_collector.name	other	RANK_STALKER
197	0ql9	Неприкосновенный запас	go.hideout_storage_emergency_ration.name	other	RANK_VETERAN
198	mvqy	Система кондиционирования	go.hideout_storage_acs.name	other	RANK_VETERAN
199	6z9p	Тележка с инструментами	go.hideout_workshop_tool_trolley.name	other	RANK_STALKER
200	gv16	Набор для работы с электроникой	go.hideout_workshop_electronics_kit.name	other	RANK_STALKER
201	yjnk	Сварочное оборудование	go.hideout_workshop_welding_equipment.name	other	RANK_VETERAN
202	w6l2	Точные электроинструменты	go.hideout_workshop_precise_powertools.name	other	RANK_VETERAN
203	kv5y	Токарный станок	go.hideout_workshop_lathe.name	other	RANK_VETERAN
204	gv96	Лабораторный стол	go.hideout_laboratory_table.name	other	RANK_STALKER
205	yj0k	Химический реактор	go.hideout_laboratory_chemical_reactor.name	other	RANK_VETERAN
206	rzpv	Кухонный стол	go.hideout_kitchen_table.name	other	RANK_STALKER
207	0qj9	Фильтр из марли	go.hideout_kitchen_gauze_filter.name	other	RANK_STALKER
208	mvyy	Кухонная плита	go.hideout_kitchen_stove.name	other	RANK_STALKER
209	n2n1	Кухонная утварь	go.hideout_kitchen_kitchen_items.name	other	RANK_STALKER
210	v4gr	Тара для брожения	go.hideout_kitchen_fermentation_container.name	other	RANK_VETERAN
211	2l3l	Вытяжка	go.hideout_kitchen_hoods.name	other	RANK_VETERAN
212	qgpj	Грузовые ящики	go.hideout_laptop_vendors.name	other	RANK_STALKER
213	9woy	Табурет	go.hideout_stool_wood_1.name	other	DEFAULT
214	1jy2	Стул	go.hideout_chair_wood_1.name	other	DEFAULT
215	gvz5	Стул	go.hideout_chair_wood_2.name	other	DEFAULT
216	zlnm	Кресло	go.hideout_armchair_1.name	other	DEFAULT
217	5g0q	Кресло	go.hideout_armchair_2.name	other	DEFAULT
218	yjv3	Диван	go.hideout_couch_1.name	other	DEFAULT
219	9wwq	Стол	go.hideout_table_wood_base_1.name	other	DEFAULT
220	1jjr	Круглый стол	go.hideout_table_wood_round_1.name	other	DEFAULT
221	zllk	Металлический стол	go.hideout_table_metal_1.name	other	DEFAULT
222	9wlz	Деревянная тумба	go.hideout_toomba_wood_1.name	other	DEFAULT
223	1jz1	Металлическая тумба	go.hideout_toomba_metal_1.name	other	DEFAULT
224	gvqp	Деревянные полки	go.hideout_shelves_wood_1.name	other	DEFAULT
225	zlrn	Стеллаж	go.hideout_rack_wood_1.name	other	DEFAULT
226	5g40	Шкаф	go.hideout_closet_wood_1.name	other	DEFAULT
227	yjlo	Шкаф	go.hideout_closet_wood_2.name	other	DEFAULT
228	95qw	Кровать	go.hideout_bed_metal.name	other	DEFAULT
229	1q0q	Матрас	go.hideout_mattress.name	other	DEFAULT
230	gong	Химсвет	go.hideout_chemlight.name	other	DEFAULT
231	95zl	Раковина	go.hideout_sink.name	other	DEFAULT
232	1qlg	Ванна	go.hideout_bathroom.name	other	DEFAULT
233	go16	Туалет	go.hideout_toilet.name	other	DEFAULT
234	z5wy	Мусорное ведро	go.hideout_trashbin.name	other	DEFAULT
235	59o1	Ковер	go.hideout_carpet_1.name	other	DEFAULT
236	yznk	Ковер	go.hideout_carpet_2.name	other	DEFAULT
237	w1l2	Ковер	go.hideout_carpet_3.name	other	DEFAULT
238	467r	Ковер	go.hideout_carpet_4.name	other	DEFAULT
239	kg5y	Ковер	go.hideout_carpet_5.name	other	DEFAULT
240	qk3j	Телевизор	go.hideout_tv_old_1.name	other	DEFAULT
241	j1z0	Телевизор	go.hideout_tv_old_2.name	other	DEFAULT
242	lz9k	Чайник	go.hideout_teapot_1.name	other	DEFAULT
243	z4v9	Детектор узкого диапазона «Белуха»	item.device.dud_beluga.name	weapon/device	RANK_STALKER
244	9j0l	Детектор узкого диапазона «Свеча»	item.device.dud_svecha.name	weapon/device	RANK_NEWBIE
245	1gmg	Детектор узкого диапазона «Бурят»	item.device.dud_buryat.name	weapon/device	RANK_VETERAN
246	gdj6	Детектор узкого диапазона «Эльбрус»	item.device.dud_elbrus.name	weapon/device	RANK_MASTER
247	gd06	СН-1 «Блин»	item.misc.cn1.name	weapon/device	DEFAULT
248	z47y	СН-1у «Блинчик»	item.misc.cn1u.name	weapon/device	DEFAULT
249	5wd1	СН-2 «Нога»	item.misc.cn2.name	weapon/device	DEFAULT
250	yw7k	СН-2у «Ножка»	item.misc.cn2u.name	weapon/device	DEFAULT
251	9rkw	Детектор широкого диапазона САК-1	item.device.dshd_sak1.name	other/device	RANK_NEWBIE
252	9r2l	Маленькая ключница	item.keyholder.small.name	other	RANK_VETERAN
253	156g	Ключница	item.keyholder.medium.name	other	RANK_VETERAN
254	g6w6	Большая ключница	item.keyholder.big.name	other	RANK_MASTER
255	zd6y	Особая ключница	item.keyholder.large.name	other	RANK_MASTER
256	9nd0	Призрачный кристалл	item.art.electra_crystal.name	artefact/electrophysical	DEFAULT
257	1k96	Трещотка	item.art.electra_bengal.name	artefact/electrophysical	DEFAULT
258	gyn0	Комета	item.art.electra_vspyshka.name	artefact/electrophysical	DEFAULT
259	zy32	Батарейка	item.art.electra_batareyka.name	artefact/electrophysical	DEFAULT
260	5r5g	Ледяной ежик	item.art.electra_snowflake.name	artefact/electrophysical	DEFAULT
261	y54z	Гиря	item.art.electra_pustishka.name	artefact/electrophysical	DEFAULT
262	wg3p	Дезинтегратор	item.art.electra_dezintegrator.name	artefact/electrophysical	DEFAULT
263	4lkp	Лампочка Ильича	item.art.electra_moonlight.name	artefact/electrophysical	DEFAULT
264	kqr0	Гелий	item.art.electra_helium.name	artefact/electrophysical	DEFAULT
265	qo06	Трансформатор	item.art.electra_transformator.name	artefact/electrophysical	DEFAULT
266	gy10	Красный кристалл	item.art.jarka_crystal.name	artefact/thermal	DEFAULT
267	zyw2	Огонек	item.art.jarka_fireball.name	artefact/thermal	DEFAULT
268	5rog	Пиявка	item.art.jarka_kaplya.name	artefact/thermal	DEFAULT
269	y5nz	Волчьи слезы	item.art.jarka_vslezy.name	artefact/thermal	DEFAULT
270	wglp	Ветка Калины	item.art.jarka_mamybusi.name	artefact/thermal	DEFAULT
271	4l7p	Гребешок	item.art.jarka_glaz.name	artefact/thermal	DEFAULT
272	kqp0	Жар-птица	item.art.jarka_plamya.name	artefact/thermal	DEFAULT
273	qoq6	Солнце	item.art.jarka_solnce.name	artefact/thermal	DEFAULT
274	ljrj	Радиатор	item.art.jarka_radiator.name	artefact/thermal	DEFAULT
275	9n1w	Ягодка	item.art.karousel_bloodstone.name	artefact/gravity	DEFAULT
276	1k4q	Сало	item.art.karousel_lomot.name	artefact/gravity	DEFAULT
277	gypg	Плод	item.art.karousel_jelch.name	artefact/gravity	DEFAULT
278	zyo9	Болотный гнилец	item.art.karousel_gnilec.name	artefact/gravity	DEFAULT
279	5r34	Сердце	item.art.karousel_dusha.name	artefact/gravity	DEFAULT
280	y5yw	Гантель	item.art.karousel_prujina.name	artefact/gravity	DEFAULT
281	wgzd	Остов	item.art.karousel_ostov.name	artefact/gravity	DEFAULT
415	nv43	Рюкзак NPA	item.bag.npa.name	backpacks	RANK_STALKER
282	gyjg	Кислотный кристалл	item.art.kisel_crystal.name	artefact/biochemical	DEFAULT
283	zyv9	Кисель	item.art.kisel_kisel.name	artefact/biochemical	DEFAULT
284	5r04	Флегма	item.art.kisel_sliz.name	artefact/biochemical	DEFAULT
285	y5vw	Скорлупа	item.art.kisel_sliznyak.name	artefact/biochemical	DEFAULT
286	wgvd	Чернильница	item.art.kisel_slyda.name	artefact/biochemical	DEFAULT
287	4lml	Змеиный глаз	item.art.kisel_svetlyak.name	artefact/biochemical	DEFAULT
288	kqj3	Улитка	item.art.kisel_ulitka.name	artefact/biochemical	DEFAULT
289	qo59	Жвачка	item.art.kisel_puzir.name	artefact/biochemical	DEFAULT
290	jkj4	Ряска	item.art.kisel_plenka.name	artefact/biochemical	DEFAULT
291	ljpq	Многогранник	item.art.kisel_poly.name	artefact/biochemical	DEFAULT
292	9nml	Репях	item.art.puh_koluchka.name	artefact/biochemical	DEFAULT
293	1kdg	Липкий репях	item.art.puh_kkoluchka.name	artefact/biochemical	DEFAULT
294	gy06	Ершик	item.art.puh_ej.name	artefact/biochemical	DEFAULT
295	zy7y	Ежик	item.art.puh_kolobok.name	artefact/biochemical	DEFAULT
296	5rd1	Стальной Ежик	item.art.puh_steelkolobok.name	artefact/biochemical	DEFAULT
297	gyv6	Роза	item.art.trampoline_kamencvet.name	artefact/gravity	DEFAULT
298	zyly	Цибуля	item.art.trampoline_meduza.name	artefact/gravity	DEFAULT
299	5rg1	Проклятая роза	item.art.trampoline_darkmeduza.name	artefact/gravity	DEFAULT
300	y5jk	Жильник	item.art.trampoline_jilnik.name	artefact/gravity	DEFAULT
301	wg62	Белая роза	item.art.trampoline_nightstar.name	artefact/gravity	DEFAULT
302	4l1r	Протоцибуля	item.art.trampoline_protomeduza.name	artefact/gravity	DEFAULT
303	kqgy	Браслет	item.art.trampoline_braslet.name	artefact/gravity	DEFAULT
304	9nvy	Вехотка	item.art.voronka_vivert.name	artefact/gravity	DEFAULT
305	1kv2	Прима	item.art.voronka_gravi.name	artefact/gravity	DEFAULT
306	gyg5	Креветка	item.art.voronka_goldfish.name	artefact/gravity	DEFAULT
307	zypm	Золотистая Прима	item.art.voronka_goldgravi.name	artefact/gravity	DEFAULT
308	5rpq	Янтарник	item.art.voronka_yantar.name	artefact/gravity	DEFAULT
309	y5m3	Криоген	item.art.voronka_kriogen.name	artefact/gravity	DEFAULT
310	wgr3	Темный кристалл	item.art.voronka_crystal.name	artefact/gravity	DEFAULT
311	gyq5	Спираль	item.art.puzir_spiral.name	artefact/electrophysical	DEFAULT
312	zyrm	Зеркало	item.art.puzir_zerkalo.name	artefact/electrophysical	DEFAULT
313	5rwq	Осколок	item.art.puzir_oskolok.name	artefact/electrophysical	DEFAULT
314	y5w3	Призма	item.art.puzir_prisma.name	artefact/electrophysical	DEFAULT
315	wg53	Атом	item.art.puzir_atom.name	artefact/electrophysical	DEFAULT
316	gyln	Иней	item.art.blizzard_frost.name	artefact/thermal	DEFAULT
317	zyqk	Хрусталь	item.art.blizzard_crystal.name	artefact/thermal	DEFAULT
318	5rzo	Корка	item.art.blizzard_crust.name	artefact/thermal	DEFAULT
319	y5k0	Вихрь	item.art.blizzard_vortex.name	artefact/thermal	DEFAULT
320	wgwz	Фаренгейт	item.art.blizzard_fahrenheit.name	artefact/thermal	DEFAULT
321	kqoj	Каблук	item.art.blizzard_heel.name	artefact/thermal	DEFAULT
322	qo94	Куриный бог	item.art.blizzard_chickengod.name	artefact/thermal	DEFAULT
323	jkml	Глаз бури	item.art.blizzard_stormeye.name	artefact/thermal	DEFAULT
324	ljn2	Морозец	item.art.blizzard_palantir.name	artefact/thermal	DEFAULT
325	9n7z	Рубик	item.art.inside_rubik.name	artefact/other_arts	DEFAULT
326	1kw1	Кристалл Изнанки	item.art.inside_crystal.name	artefact/other_arts	DEFAULT
327	gy7p	Сетчатка	item.art.inside_setchatka.name	artefact/other_arts	DEFAULT
328	zymn	Смалец	item.art.inside_smalets.name	artefact/other_arts	DEFAULT
329	5rm0	Ключик	item.art.inside_key.name	artefact/other_arts	DEFAULT
330	y5ro	Яйцо	item.art.inside_egg.name	artefact/other_arts	DEFAULT
331	wgko	Роза Изнанки	item.art.inside_rose.name	artefact/other_arts	DEFAULT
332	4lrn	Висмут	item.art.inside_bismuth.name	artefact/other_arts	DEFAULT
333	kq4v	Темная калина	item.art.inside_kalina.name	artefact/other_arts	DEFAULT
334	qodk	Бубльгум	item.art.inside_bubblegum.name	artefact/other_arts	DEFAULT
335	jky6	Изюм	item.art.inside_izum.name	artefact/other_arts	DEFAULT
336	w4no	Канифоль	item.art.murmur_rosin.name	artefact/other_arts	DEFAULT
337	49zn	Нервяк	item.art.murmur_nerves.name	artefact/other_arts	DEFAULT
338	k3yv	Обруч	item.art.murmur_hoop.name	artefact/other_arts	DEFAULT
339	q1lk	Жабры	item.art.murmur_gills.name	artefact/other_arts	DEFAULT
340	j3p6	Смольник	item.art.murmur_smolnik.name	artefact/other_arts	DEFAULT
341	9ypy	Стальная пластина I	item.plate.steel1.name	other	DEFAULT
342	1p32	Стальная пластина II	item.plate.steel2.name	other	DEFAULT
343	g325	Стальная пластина III	item.plate.steel3.name	other	DEFAULT
344	zj9m	Стальная пластина IV	item.plate.steel4.name	other	DEFAULT
345	514q	Стальная пластина V	item.plate.steel5.name	other	DEFAULT
346	j3rg	Керамическая пластина I	item.plate.ceramic1.name	other	DEFAULT
347	l3mo	Керамическая пластина II	item.plate.ceramic2.name	other	DEFAULT
348	rg5y	Керамическая пластина III	item.plate.ceramic3.name	other	DEFAULT
349	0ngy	Керамическая пластина IV	item.plate.ceramic4.name	other	DEFAULT
350	m3o2	Керамическая пластина V	item.plate.ceramic5.name	other	DEFAULT
351	o31m	Экспериментальная пластина	item.plate.experimental.name	other	DEFAULT
352	2v55	Композитная пластина I	item.plate.composite1.name	other	DEFAULT
353	3dy5	Композитная пластина II	item.plate.composite2.name	other	DEFAULT
354	7zqj	Композитная пластина III	item.plate.composite3.name	other	DEFAULT
355	6gk0	Композитная пластина IV	item.plate.composite4.name	other	DEFAULT
356	9yly	Композитная пластина V	item.plate.composite5.name	other	DEFAULT
357	1pz2	Уплотненная стальная пластина	item.plate.steel3_frontline.name	other	DEFAULT
358	g3q5	Крепкая стальная пластина	item.plate.steel5_frontline.name	other	DEFAULT
359	zjrm	Крепкая композитная пластина	item.plate.composite5_frontline.name	other	DEFAULT
360	j3dg	Стеклянная пластина V	item.plate.glass5.name	other	DEFAULT
361	2vz5	Ониксовая пластина V	item.plate.onyx5.name	other	DEFAULT
362	w4d3	Утепленная пластина V	item.plate.meh5.name	other	DEFAULT
363	rg7y	Экспериментальная термопластина I	item.plate.radiator1.name	other	DEFAULT
364	0nzy	Экспериментальная термопластина II	item.plate.radiator2.name	other	DEFAULT
365	m372	Экспериментальная термопластина III	item.plate.radiator3.name	other	DEFAULT
366	o37m	Экспериментальная термопластина IV	item.plate.radiator4.name	other	DEFAULT
367	n372	Экспериментальная термопластина V	item.plate.radiator5.name	other	DEFAULT
368	9yyq	Контейнер «КЗС-1»	item.cont.kzs1.name	containers	DEFAULT
369	yqq0	Контейнер «КЗС-1у»	item.cont.kzs1u.name	containers	DEFAULT
370	j33l	Контейнер «КЗС-2»	item.cont.kzs2.name	containers	RANK_NEWBIE
371	l332	Рюкзак «Хелбой»	item.bag.hellboy.name	backpacks	RANK_NEWBIE
372	o335	Контейнер «КЗС-2У»	item.cont.kzs2u.name	containers	RANK_STALKER
373	n339	Рюкзак «Хелбой-У»	item.bag.hellboyu.name	backpacks	RANK_STALKER
374	p99d	Контейнер «ИУ-2»	item.cont.iu2.name	containers	RANK_VETERAN
375	2vvv	Контейнер «КЗС-М»	item.cont.kzs3.name	containers	RANK_STALKER
376	9y4q	Контейнер «Кокон»	item.cont.cocoon.name	containers	RANK_NEWBIE
377	1p2r	Контейнер «КЗС-МУ»	item.cont.kzs3u.name	containers	RANK_VETERAN
378	g3ln	Контейнер «Холодильник»	item.cont.fridge.name	containers	RANK_VETERAN
379	zjqk	Марафонская сумка	item.cont.pouch.name	backpacks	RANK_VETERAN
380	51zo	«Вьюк»	item.cont.pouch_hunter.name	backpacks	RANK_VETERAN
381	yqk0	Контейнер «Кокон-У»	item.cont.cocoonu.name	containers	RANK_STALKER
382	w4wz	Контейнер «Берлога-4»	item.cont.bear4.name	containers	RANK_NEWBIE
383	k3oj	Контейнер «Сота»	item.cont.honeycomb.name	containers	RANK_STALKER
384	q194	Контейнер «Добытчик»	item.cont.getter.name	containers	RANK_VETERAN
385	j3ml	Контейнер «КСМ»	item.cont.ksm.name	containers	RANK_MASTER
386	l3n2	Контейнер «Берлога-4у»	item.cont.bear4u.name	containers	RANK_STALKER
387	0ndk	Ягдташ	item.bag.tasche.name	backpacks	RANK_VETERAN
388	o3d5	Контейнер «Сота-У»	item.cont.honeycombu.name	containers	RANK_VETERAN
389	n3v9	Контейнер «Пасека»	item.cont.apiary.name	containers	RANK_LEGEND
390	p92d	Контейнер «Улей»	item.cont.hive.name	containers	RANK_MASTER
391	v6y7	Контейнер «Бидон»	item.cont.bidon.name	containers	RANK_NEWBIE
392	d3kg	Контейнер «Берлога-5»	item.cont.bear5.name	containers	RANK_STALKER
393	2v9v	Контейнер «Колотун»	item.cont.kolotun.name	containers	RANK_VETERAN
394	6g5n	Контейнер «Бидон-У»	item.cont.bidonu.name	containers	RANK_STALKER
395	9ygq	Контейнер «Берлога-5У»	item.cont.bear5u.name	containers	RANK_VETERAN
396	g35n	Контейнер «Берлога-6»	item.cont.bear6.name	containers	RANK_MASTER
397	zj1k	Контейнер «Кега»	item.cont.kega.name	containers	RANK_STALKER
398	512o	ZIVCAS ArcticSafe-6	item.cont.zivcas.name	containers	RANK_MASTER
399	yq90	Рюкзак «Хитин»	item.bag.murmur.name	backpacks	RANK_LEGEND
400	w42z	Контейнер «Овертон»	item.cont.overtone.name	containers	RANK_MASTER
401	k3kj	Контейнер «Кега-УЭ»	item.cont.kegaue.name	containers	RANK_VETERAN
402	q1m4	Контейнер «Берлога-6у»	item.cont.bear6u.name	containers	RANK_LEGEND
403	rgoz	Контейнер «Бочонок»	item.cont.barrel.name	containers	RANK_MASTER
404	0nok	Контейнер «Вязанка»	item.cont.pathfinder.name	containers	RANK_MASTER
405	jmp6	Сумка-трансформер	item.bag.transformer.name	backpacks	DEFAULT
406	odq0	Спортивная сумка	item.bag.sports.name	backpacks	RANK_NEWBIE
407	nv63	Поясная сумка PROTECT 3B	item.bag.light1.name	backpacks	RANK_STALKER
408	p2k2	Подсумок Black Eagle B-33	item.bag.light2.name	backpacks	RANK_STALKER
409	vyqd	Разгрузка Black Eagle Y-73	item.bag.light3.name	backpacks	RANK_VETERAN
410	dkln	Разгрузка ADR-WRBT	item.bag.light4.name	backpacks	RANK_MASTER
411	29o6	Вещмешок	item.bag.sack.name	backpacks	DEFAULT
412	12r1	Рюкзак Errand Junior	item.bag.errand.name	backpacks	RANK_NEWBIE
413	wwjo	Рюкзак MBSS	item.bag.mbss.name	backpacks	RANK_STALKER
414	lny1	Штурмовой рюкзак Tri-Zip	item.bag.trizip.name	backpacks	RANK_STALKER
416	p262	Рюкзак «Гроб»	item.bag.heavy1.name	backpacks	RANK_MASTER
417	glnp	Советский походный рюкзак	item.bag.march.name	backpacks	RANK_VETERAN
418	zq3n	Рюкзак Secret Valley 35	item.bag.medium1.name	backpacks	RANK_MASTER
419	jm94	РГН	item.exp.rgn.name	grenade	RANK_NEWBIE
420	lngq	РГО	item.exp.rgo.name	grenade	RANK_STALKER
421	nvpw	СЗГ «Вспышка»	item.exp.vspishka.name	grenade	RANK_NEWBIE
422	p2r5	M84	item.exp.m84.name	grenade	DEFAULT
423	vyrg	M84 QD	item.exp.m84qd.name	grenade	RANK_STALKER
424	dkq9	РГД-5	item.exp.rgd5.name	grenade	RANK_STALKER
425	29dm	Ф-1	item.exp.f1.name	grenade	RANK_VETERAN
426	31rk	M67	item.exp.m67.name	grenade	RANK_STALKER
427	7yrr	V40 Mini-Grenade	item.exp.v40.name	grenade	RANK_NEWBIE
428	65r6	Выстрел гранатометный ВОГ-25	item.exp.vog25.name	grenade	RANK_VETERAN
429	94mw	Выстрел гранатометный ВОГ-25П «Подкидыш»	item.exp.vog25p.name	grenade	RANK_VETERAN
430	12dq	Выстрел гранатометный M381	item.exp.m381.name	grenade	RANK_VETERAN
431	gl0g	Выстрел гранатометный M397	item.exp.m397.name	grenade	RANK_VETERAN
432	wwod	M18 Claymore	go.exp.claymore.name	other	RANK_MASTER
433	7ynr	Выстрел гранатометный M2	item.exp.m381_2.name	grenade	DEFAULT
434	319k	Аккумулятор для винтовки Гаусса	item.amm.akumulatora.name	bullet	DEFAULT
435	9g6z	Патрон 9 мм	item.amm.9st.name	bullet	DEFAULT
436	1nr1	Патрон 9 мм бронебойный	item.amm.9bb.name	bullet	DEFAULT
437	g54p	Патрон 9 мм экспансивный	item.amm.9exp.name	bullet	DEFAULT
438	z1zn	Патрон 9 мм зажигательный	item.amm.9inc.name	bullet	DEFAULT
439	52l0	Патрон 9 мм СБП	item.amm.9sbp.name	bullet	DEFAULT
440	kknv	Морозный выстрел	item.amm.12frz.name	bullet	DEFAULT
441	qmjk	Зажигательные 12 калибра	item.amm.12inc.name	bullet	DEFAULT
442	j456	Картечь 12 калибра	item.amm.12kar.name	bullet	DEFAULT
443	l6y1	Дробь 12 калибра	item.amm.12drob.name	bullet	DEFAULT
444	row5	Охотничья пуля 12 калибра	item.amm.12slug.name	bullet	DEFAULT
445	0or1	Боевая пуля 12 калибра	item.amm.12dart.name	bullet	DEFAULT
446	mj07	Патрон 5.45 мм	item.amm.545st.name	bullet	DEFAULT
447	ork0	Патрон 5.45 мм бронебойный	item.amm.545bb.name	bullet	DEFAULT
448	nl43	Патрон 5.45 мм экспансивный	item.amm.545exp.name	bullet	DEFAULT
449	p062	Патрон 5.45 мм зажигательный	item.amm.545inc.name	bullet	DEFAULT
450	vdjd	Патрон 5.45 мм СБП	item.amm.545sbp.name	bullet	DEFAULT
451	d1mn	Патрон 5.56 мм	item.amm.556st.name	bullet	DEFAULT
452	2p16	Патрон 5.56 мм бронебойный	item.amm.556bb.name	bullet	DEFAULT
453	3v4g	Патрон 5.56 мм экспансивный	item.amm.556exp.name	bullet	DEFAULT
454	7977	Патрон 5.56 мм зажигательный	item.amm.556inc.name	bullet	DEFAULT
455	63oy	Патрон 5.56 мм СБП	item.amm.556sbp.name	bullet	DEFAULT
456	1n91	Патрон 7.62 мм	item.amm.762st.name	bullet	DEFAULT
457	g5np	Патрон 7.62 мм бронебойный	item.amm.762bb.name	bullet	DEFAULT
458	z13n	Патрон 7.62 мм экспансивный	item.amm.762exp.name	bullet	DEFAULT
459	5250	Патрон 7.62 мм зажигательный	item.amm.762inc.name	bullet	DEFAULT
460	y94o	Патрон 7.62 мм СБП	item.amm.762sbp.name	bullet	DEFAULT
461	w23o	Патрон 9x39 мм СП-5	item.amm.939st.name	bullet	DEFAULT
462	4dkn	Патрон 9x39 мм СП-6	item.amm.939bb.name	bullet	DEFAULT
463	kkrv	Патрон 9x39 мм СБП	item.amm.939sbp.name	bullet	DEFAULT
464	qm0k	Крупнокалиберный самодельный патрон	item.amm.12st.name	bullet	DEFAULT
465	j406	Крупнокалиберный самодельный патрон (старый)	item.amm.12bb.name	bullet	DEFAULT
466	l601	Патрон 7.62 мм снайперский	item.amm.762snp.name	bullet	DEFAULT
467	roj5	Улучшенный аккумулятор для винтовки Гаусса	item.amm.akumulatorb.name	bullet	DEFAULT
468	0o01	Аккумулятор для винтовки Гаусса	item.amm.akumulatora.name	bullet	DEFAULT
469	mjr7	Аккумулятор CR-380	item.12738.name	bullet	DEFAULT
470	nlk3	Патрон 10 мм	item.amm.10st.name	bullet	DEFAULT
471	p0j2	Патрон 10 мм зажигательный	item.amm.10inc.name	bullet	DEFAULT
472	vdnd	Баллон с горючей смесью	item.amm.gas.name	bullet	DEFAULT
473	d1rn	Патрон 7.62 мм специальный	item.amm.762spec.name	bullet	DEFAULT
474	2pr6	Баллон с горючей смесью	item.amm.gas_small.name	bullet	DEFAULT
475	3vog	Патрон 12.7 мм	item.amm.127st.name	bullet	DEFAULT
476	79w7	Патрон 12.7 мм ПП	item.amm.127bb.name	bullet	DEFAULT
477	63yy	Патрон 12.7 мм снайперский	item.amm.127snp.name	bullet	DEFAULT
478	9g3z	item.amm.556st_frontline.name	item.amm.556st_frontline.name	bullet	DEFAULT
479	1no1	Патрон 12.7 мм	item.amm.127st.name	bullet	DEFAULT
480	g5kp	Баллон с горючей смесью	item.amm.gas.name	bullet	DEFAULT
481	9gk0	Патрон 9 мм жгучий	item.amm.9fire.name	bullet	DEFAULT
482	1n16	Патрон 12 калибра жгучий	item.amm.12slugfire.name	bullet	DEFAULT
483	g590	Патрон 5.45 мм жгучий	item.amm.545fire.name	bullet	DEFAULT
484	z102	Патрон 5.56 мм жгучий	item.amm.556fire.name	bullet	DEFAULT
485	526g	Патрон 7.62 мм жгучий	item.amm.762fire.name	bullet	DEFAULT
486	y90z	Патрон 9x39 мм жгучий	item.amm.939fire.name	bullet	DEFAULT
487	w20p	Крупнокалиберный жгучий патрон	item.amm.12fire.name	bullet	DEFAULT
488	4d5p	Патрон 12.7 мм жгучий	item.amm.127fire.name	bullet	DEFAULT
489	j4z7	Патрон 9 мм серебряный	item.amm.9silver.name	bullet	DEFAULT
490	l69j	Патрон 12 калибра серебряный	item.amm.12slugsilver.name	bullet	DEFAULT
491	ro6g	Патрон 5.45 мм серебряный	item.amm.545silver.name	bullet	DEFAULT
492	0o9d	Патрон 5.56 мм серебряный	item.amm.556silver.name	bullet	DEFAULT
493	mj1j	Патрон 7.62 мм серебряный	item.amm.762silver.name	bullet	DEFAULT
494	orzo	Патрон 9x39 мм серебряный	item.amm.939silver.name	bullet	DEFAULT
495	nln6	Крупнокалиберный серебряный патрон	item.amm.12silver.name	bullet	DEFAULT
496	p0n6	Патрон 12.7 мм серебряный	item.amm.127silver.name	bullet	DEFAULT
497	d1p5	Патрон 10 мм бронебойный	item.amm.10bb.name	bullet	DEFAULT
498	2p30	Патрон 10 мм СБП	item.amm.10sbp.name	bullet	DEFAULT
499	3v3z	Патрон 9x39 мм зажигательный	item.amm.939inc.name	bullet	DEFAULT
500	7933	Патрон 9 мм СЭП	item.amm.9sep.name	bullet	DEFAULT
501	637j	Патрон 10 мм СЭП	item.amm.10sep.name	bullet	DEFAULT
502	9g10	Патрон 5.45 мм СЭП	item.amm.545sep.name	bullet	DEFAULT
503	1n46	Патрон 5.56 мм СЭП	item.amm.556sep.name	bullet	DEFAULT
504	g5p0	Патрон 7.62 мм СЭП	item.amm.762sep.name	bullet	DEFAULT
505	z1o2	Патрон 9x39 мм СЭП	item.amm.939sep.name	bullet	DEFAULT
506	523g	Патрон 5.45 «Ши-3»	item.amm.545psy.name	bullet	DEFAULT
507	y9yz	Патрон 5.56 «Курчатов»	item.amm.556rad.name	bullet	DEFAULT
508	w2zp	Патрон 10 мм разрывной	item.amm.10boom.name	bullet	DEFAULT
509	4d3p	Патрон 7.62 мм «Динозавр»	item.amm.762ap.name	bullet	DEFAULT
510	kkz0	Патрон 9 мм «Сосуля»	item.amm.9frs.name	bullet	DEFAULT
511	qmn6	Патрон 9x39 мм «Электросвинг»	item.amm.939elc.name	bullet	DEFAULT
512	j4g7	Патрон 12.7 мм Easy mode	item.amm.127sft.name	bullet	DEFAULT
513	l65j	Патрон 9 мм дальнобойный	item.amm.9far.name	bullet	DEFAULT
514	ropg	Патрон 9x39 мм дальнобойный	item.amm.939far.name	bullet	DEFAULT
515	0ojd	Патрон 5.56 мм «Прогрев»	item.amm.556thr.name	bullet	DEFAULT
516	mjyj	Патрон 12 калибра «Кислотный дракон»	item.amm.12txc.name	bullet	DEFAULT
517	1r0y6	Ручная граната «Кустарник-1»	item.exp.kustarnik.name	grenade	DEFAULT
518	g4rz0	Самодельный светошум	item.exp.homemade_flashbang.name	grenade	DEFAULT
519	1r03g	Сумка зажигательных 10 мм	item.bag.10inc.name	bullet	RANK_VETERAN
520	g4r26	Сумка бронебойных 10 мм	item.bag.10bb.name	bullet	RANK_STALKER
521	zzg9y	Сумка СБП 10 мм	item.bag.10sbp.name	bullet	RANK_VETERAN
522	5lqp1	Сумка зажигательных 9x39 мм	item.bag.939inc.name	bullet	RANK_VETERAN
523	y31mk	Сумка СЭП 9 мм	item.bag.9sep.name	bullet	RANK_VETERAN
524	wjnr2	Сумка СЭП 10 мм	item.bag.10sep.name	bullet	RANK_VETERAN
525	4qzpr	Сумка СЭП 5.45 мм	item.bag.545sep.name	bullet	RANK_VETERAN
526	kny0y	Сумка СЭП 5.56 мм	item.bag.556sep.name	bullet	RANK_VETERAN
527	qjlzj	Сумка СЭП 7.62 мм	item.bag.762sep.name	bullet	RANK_VETERAN
528	j5pr0	Сумка СЭП 9x39 мм	item.bag.939sep.name	bullet	RANK_VETERAN
529	lywmk	Сумка 5.45 «Ши-3»	item.bag.545psy.name	bullet	RANK_MASTER
530	rwl5v	Сумка 5.56 «Курчатов»	item.bag.556rad.name	bullet	RANK_MASTER
531	0rwg9	Сумка взрывных 10 мм	item.bag.10boom.name	bullet	RANK_MASTER
532	m0woy	Сумка 7.62 мм «Динозавр»	item.bag.762ap.name	bullet	RANK_MASTER
533	okq16	Сумка 9 мм «Сосуля»	item.bag.9frs.name	bullet	RANK_MASTER
534	n4691	Сумка 9x39 мм «Электросвинг»	item.bag.939elc.name	bullet	RANK_MASTER
535	p6kgw	Сумка 12.7 мм Easy mode	item.bag.127sft.name	bullet	RANK_MASTER
536	vjqkr	Сумка дальнобойных 9 мм	item.bag.9far.name	bullet	RANK_MASTER
537	dmlwj	Сумка дальнобойных 9x39 мм	item.bag.939far.name	bullet	RANK_MASTER
538	2o65l	Сумка 5.56 мм «Прогрев»	item.bag.556thr.name	bullet	RANK_MASTER
539	3g0yl	Сумка патронов 12 калибра «Кислотный дракон»	item.bag.12txc.name	bullet	RANK_MASTER
540	7l4q6	Ящик кустарных гранат	item.crate.homemade.name	misc	RANK_STALKER
541	6wmkp	Ящик гранат «Кустарник-1»	item.crate.kustarnik.name	misc	RANK_STALKER
542	96qll	Ящик самодельных светошумов	item.crate.homemade_flashbang.name	misc	RANK_VETERAN
543	1r0zg	Ящик кустарных ВОГ-25	item.crate.vog25_crafted.name	misc	RANK_VETERAN
544	g4rq6	Ящик кустарных ВОГ-25П	item.crate.vog25p_crafted.name	misc	RANK_VETERAN
545	zzgry	Ящик самодельных M381	item.crate.m381_crafted.name	misc	RANK_VETERAN
546	5lq41	Ящик самодельных M397	item.crate.m397_crafted.name	misc	RANK_VETERAN
547	y31lk	Ящик самодельных мини-гранат	item.crate.mini_crafted.name	misc	RANK_VETERAN
548	wjnq2	Ящик кустарных осколочных гранат	item.crate.frag_crafted.name	misc	RANK_VETERAN
549	knydy	Ящик гранат «Завеса»	item.crate.craft_smoke.name	misc	RANK_MASTER
550	qjl6j	Ящик гранат «Искра»	item.crate.craft_flash.name	misc	RANK_MASTER
551	j5pd0	Ящик гранат «Гром»	item.crate.craft_thunder.name	misc	RANK_MASTER
552	lywdk	Ящик гранат «Напалм»	item.crate.craft_napalm.name	misc	RANK_MASTER
553	rwldv	Ящик гранат «Вьюга»	item.crate.craft_snowstorm.name	misc	RANK_MASTER
554	0rw19	Ящик гранат «Гудрон»	item.crate.craft_stunner.name	misc	RANK_MASTER
555	m0wdy	Ящик гранат «Подорожник»	item.crate.craft_heal.name	misc	RANK_MASTER
556	okq26	Ящик гранат «Хворь»	item.crate.craft_sickness.name	misc	RANK_MASTER
557	n46d1	Ящик гранат «Вонючка»	item.crate.craft_stinker.name	misc	RANK_MASTER
558	dmldj	Сумка стальных пластин III	item.bag.armorpack_steel3.name	misc	RANK_STALKER
559	2o6zl	Сумка стальных пластин IV	item.bag.armorpack_steel4.name	misc	RANK_VETERAN
560	3g05l	Сумка стальных пластин V	item.bag.armorpack_steel5.name	misc	RANK_MASTER
561	96qjl	Сумка керамических пластин III	item.bag.armorpack_ceramic3.name	misc	RANK_STALKER
562	1r0gg	Сумка керамических пластин IV	item.bag.armorpack_ceramic4.name	misc	RANK_VETERAN
563	g4rd6	Сумка керамических пластин V	item.bag.armorpack_ceramic5.name	misc	RANK_MASTER
564	y31wk	Сумка композитных пластин III	item.bag.armorpack_composite3.name	misc	RANK_STALKER
565	wjn52	Сумка композитных пластин IV	item.bag.armorpack_composite4.name	misc	RANK_VETERAN
566	4qzyr	Сумка композитных пластин V	item.bag.armorpack_composite5.name	misc	RANK_MASTER
567	7lwvj	Расписка от Шамана	item.16122.name	other	QUEST_ITEM
568	0rl9k	Голова крысы	item.misc.tushkan_head_t2.name	misc	DEFAULT
569	1rl4r	Хвост сильной шавки	item.misc.dog_tail_t3.name	misc	DEFAULT
570	5lo3o	Копыто сильного кабана	item.misc.boar_hoof_t3.name	misc	RANK_VETERAN
571	dmypg	Едкое мясо бестии	item.misc.chimera_meat.name	misc	RANK_STALKER
572	p6qz2	Черный Регалий	item.clan.black_regaliy.name	misc	DEFAULT
573	3gqkg	Нестабильная аномальная батарея	item.misc.anomal_battery.name	misc	RANK_MASTER
574	7l127	Аномальная пыль	item.misc.anomal_dust.name	misc	RANK_STALKER
575	96z2z	Хронопыль	item.misc.chrono_dust.name	misc	RANK_VETERAN
576	1rl61	Хроносфера	item.misc.chronosphere.name	misc	RANK_VETERAN
577	1rl71	Пыль изменения	item.misc.change_dust.name	misc	RANK_VETERAN
578	5logg	Странный артефакт	item.misc.strange_artefact.name	misc	RANK_NEWBIE
579	y3nmw	Продвинутые запчасти	item.upg.protector.name	other	RANK_MASTER
580	wjlrd	Дешевые инструменты	item.upg.tools_1.name	other	RANK_NEWBIE
581	4q7pl	Продвинутые инструменты	item.upg.tools_3.name	other	RANK_MASTER
582	knp93	Особые инструменты	item.upg.tools_2a.name	other	RANK_VETERAN
583	qjqw9	Стандартные инструменты	item.upg.tools_2.name	other	RANK_STALKER
584	okp24	Сумка бронебойных 9 мм	item.bag.9bb.name	bullet	RANK_STALKER
585	n4wdw	Сумка боевых пуль 12х76 мм	item.bag.12dart.name	bullet	RANK_STALKER
586	p6qd5	Сумка бронебойных 5.45 мм	item.bag.545bb.name	bullet	RANK_STALKER
587	vj3zg	Сумка бронебойных 5.56 мм	item.bag.556bb.name	bullet	RANK_STALKER
588	dmyd9	Сумка бронебойных 7.62 мм	item.bag.762bb.name	bullet	RANK_STALKER
589	2o0zm	Сумка СП-6 9x39 мм	item.bag.939bb.name	bullet	RANK_STALKER
590	7l1kr	Подсумок с аптечками проводника	item.pouch.apt_p.name	medicine	RANK_VETERAN
591	96zjw	Подсумок с аптечками ученых	item.pouch.apt_s.name	medicine	RANK_STALKER
592	1rlgq	Подсумок с военными аптечками	item.pouch.apt_a.name	medicine	DEFAULT
593	4q7yl	Сумка СБП 9 мм	item.bag.9sbp.name	bullet	RANK_VETERAN
594	knpd3	Сумка СБП 5.45 мм	item.bag.545sbp.name	bullet	RANK_VETERAN
595	qjq69	Сумка СБП 5.56 мм	item.bag.556sbp.name	bullet	RANK_VETERAN
596	j5qd4	Сумка СБП 7.62 мм	item.bag.762sbp.name	bullet	RANK_VETERAN
597	lyrdq	Сумка СБП 9x39 мм	item.bag.939sbp.name	bullet	RANK_VETERAN
598	rwv7l	Сумка зажигательных 9 мм	item.bag.9inc.name	bullet	RANK_VETERAN
599	0rlzr	Сумка зажигательных 12х76 мм	item.bag.12inc.name	bullet	RANK_VETERAN
600	m0q7r	Сумка зажигательных 5.45 мм	item.bag.545inc.name	bullet	RANK_VETERAN
601	okp74	Сумка зажигательных 5.56 мм	item.bag.556inc.name	bullet	RANK_VETERAN
602	n4w7w	Сумка зажигательных 7.62 мм	item.bag.762inc.name	bullet	RANK_VETERAN
603	96z7y	Катализатор	item.art.mod_catalyst.name	misc	DEFAULT
604	1rlw2	Эссенция сброса	item.art.mod_reroll.name	other	RANK_MASTER
605	zzwmm	Сыворотка изменения	item.art.mod_change.name	other	RANK_MASTER
606	96kkq	Расписка от Липы	item.quest.raspiska_lipi.name	other	QUEST_ITEM
607	96kw0	ГП-25 «Костер»	item.att.launcher_gp25.name	attachment/other	RANK_VETERAN
608	1r1j6	M203	item.att.launcher_m203.name	attachment/other	RANK_VETERAN
609	g49v0	Гранатомет для ОЦ-14 «Гроза»	item.att.launcher_groza.name	attachment/other	RANK_VETERAN
610	5l6gg	Гранатомет FN EGLM	item.att.launcher_eglm.name	attachment/other	RANK_VETERAN
611	96o1q	Оружейная краска «Золотая»	item.18000.name	other	RANK_MASTER
678	dm925	Камуфляж «ERDL USCM»	item.18219.name	other	RANK_NEWBIE
612	1ry4r	Оружейная краска «Красная»	item.camo.wpn.red.name	other	RANK_NEWBIE
613	g4zpn	Оружейная краска «Оранжевая»	item.camo.wpn.orange.name	other	RANK_NEWBIE
614	zznok	Оружейная краска «Желтая»	item.camo.wpn.yellow.name	other	RANK_NEWBIE
615	5lj3o	Оружейная краска «Зеленая»	item.camo.wpn.green.name	other	RANK_NEWBIE
616	y36y0	Оружейная краска «Голубая»	item.camo.wpn.blue.name	other	RANK_NEWBIE
617	wjyzz	Оружейная краска «Синяя»	item.camo.wpn.indigo.name	other	RANK_NEWBIE
618	4qj3j	Оружейная краска «Фиолетовая»	item.camo.wpn.violet.name	other	RANK_NEWBIE
619	kn2zj	Оружейная краска «Черная»	item.camo.wpn.black.name	other	RANK_NEWBIE
620	qjpn4	Оружейная краска «Белая»	item.camo.wpn.white.name	other	RANK_NEWBIE
621	j5wgl	Оружейная краска «Хаки»	item.camo.wpn.sand.name	other	RANK_NEWBIE
622	lyo52	Оружейная краска «Оливковая»	item.camo.wpn.oliva.name	other	RANK_NEWBIE
623	rw9pz	Оружейная краска «Коричневая»	item.camo.wpn.brown.name	other	RANK_NEWBIE
624	0r6jk	Оружейная краска «Розовая»	item.camo.wpn.pink.name	other	RANK_MASTER
625	m0nyk	Оружейная краска «Серая»	item.camo.wpn.grey.name	other	RANK_NEWBIE
626	96omz	Камуфляж «Бутан»	item.camo.wpn.butan.name	other	RANK_NEWBIE
627	1ryd1	Камуфляж «Бутан - Скалистый берег»	item.18101.name	other	RANK_NEWBIE
628	g4z0p	Камуфляж «Березка»	item.18102.name	other	RANK_NEWBIE
629	zzn7n	Камуфляж «Сурпат»	item.18103.name	other	RANK_NEWBIE
630	5ljd0	Камуфляж «Сурпат - Городской шум»	item.18104.name	other	RANK_NEWBIE
631	y367o	Камуфляж «Жаба»	item.18105.name	other	RANK_NEWBIE
632	wjyoo	Камуфляж «Жаба - белый»	item.18106.name	other	RANK_NEWBIE
633	4qj0n	Камуфляж «Флора»	item.18107.name	other	RANK_NEWBIE
634	kn2lv	Камуфляж «Дюна»	item.18108.name	other	RANK_NEWBIE
635	qjpvk	Камуфляж «Волна»	item.18109.name	other	RANK_NEWBIE
636	j5wl6	Камуфляж «Излом»	item.18110.name	other	RANK_NEWBIE
637	lyol1	Камуфляж «Скол»	item.18111.name	other	RANK_NEWBIE
638	rw9r5	Камуфляж «Спектр»	item.18112.name	other	RANK_NEWBIE
639	0r631	Камуфляж «Спектр - почва»	item.18113.name	other	RANK_NEWBIE
640	m0n27	Камуфляж «Гелетейка»	item.18114.name	other	RANK_NEWBIE
641	ok6v0	Камуфляж «Городской четырехцветный»	item.18115.name	other	RANK_NEWBIE
642	n4op3	Камуфляж «Русская цифра»	item.18116.name	other	RANK_NEWBIE
643	p6or2	Камуфляж «Гравий»	item.18117.name	other	RANK_NEWBIE
644	vj5rd	Камуфляж «Березка» обр. 1943 г.	item.18118.name	other	RANK_STALKER
645	dm9qn	Камуфляж «Амеба» обр. 1942 г.	item.18119.name	other	RANK_STALKER
646	2own6	Камуфляж «Пальмовая амеба»	item.18120.name	other	RANK_NEWBIE
647	3g2ng	Камуфляж «Северный склон»	item.18121.name	other	RANK_NEWBIE
648	7ldn7	Камуфляж «Хуртовина»	item.camo.wpn.geleteika_winter.name	other	RANK_NEWBIE
649	6wj6y	Камуфляж «Хлопья»	item.camo.wpn.flake.name	other	RANK_NEWBIE
650	96o9z	Камуфляж «Бутан - Снег»	item.camo.wpn.butan_snow.name	other	RANK_NEWBIE
651	1ry71	Камуфляж «Буря»	item.camo.wpn.burya.name	other	RANK_NEWBIE
652	g4zmp	Камуфляж «Белорусская цифра»	item.18126.name	other	RANK_NEWBIE
653	zzn2n	Цифровой камуфляж Казахстана	item.18127.name	other	RANK_NEWBIE
654	5ljn0	Камуфляж «Поле»	item.camo.wpn.field.name	other	RANK_NEWBIE
655	y362o	Камуфляж «Гряда»	item.camo.wpn.gryada.name	other	RANK_STALKER
656	wjy7o	Камуфляж «Цифровой тигр»	item.camo.wpn.tiger_digital.name	other	RANK_NEWBIE
657	4qjnn	Камуфляж «Спад»	item.camo.wpn.spad.name	other	RANK_NEWBIE
658	kn2mv	Камуфляж «Ельник»	item.camo.wpn.fir.name	other	RANK_STALKER
659	96ov0	Камуфляж «A-TACS FG»	item.18200.name	other	RANK_NEWBIE
660	1ryv6	Камуфляж «A-TACS AU»	item.18201.name	other	RANK_NEWBIE
661	g4zg0	Камуфляж «Hexagon-A»	item.18202.name	other	RANK_NEWBIE
662	zznp2	Камуфляж «Hexagon-B»	item.18203.name	other	RANK_NEWBIE
663	5ljvg	Камуфляж «Digital-A»	item.18204.name	other	RANK_NEWBIE
664	y36pz	Камуфляж «Digital-B»	item.18205.name	other	RANK_NEWBIE
665	wjypp	Камуфляж «Belgian Jigsaw»	item.18206.name	other	RANK_NEWBIE
666	4qjvp	Камуфляж «Belgian Jigsaw Desert»	item.18207.name	other	RANK_NEWBIE
667	kn2w0	Камуфляж «M90»	item.18208.name	other	RANK_NEWBIE
668	qjpr6	Камуфляж «M90 Night»	item.18209.name	other	RANK_NEWBIE
669	j5w67	Камуфляж «M90 Desert»	item.18210.name	other	RANK_NEWBIE
670	lyo4j	Камуфляж «M90 Urban»	item.18211.name	other	RANK_NEWBIE
671	rw90g	Камуфляж «ERDL ARVN Red»	item.18212.name	other	RANK_NEWBIE
672	0r6vd	Камуфляж «ERDL ARVN SV»	item.18213.name	other	RANK_NEWBIE
673	m0nkj	Камуфляж «ERDL ARVN Yellow»	item.18214.name	other	RANK_NEWBIE
674	ok6jo	Камуфляж «ERDL Red»	item.18215.name	other	RANK_NEWBIE
675	n4oz6	Камуфляж «ERDL Stinger»	item.18216.name	other	RANK_NEWBIE
676	p6oy6	Камуфляж «ERDL Streetfighter»	item.18217.name	other	RANK_NEWBIE
677	vj5ln	Камуфляж «ERDL Urban»	item.18218.name	other	RANK_NEWBIE
679	2ow70	Камуфляж «ERDL Woodland»	item.18220.name	other	RANK_NEWBIE
680	3g2pz	Камуфляж «Multicam»	item.18221.name	other	RANK_NEWBIE
681	7ldp3	Камуфляж «DPM Desert»	item.18222.name	other	RANK_NEWBIE
682	6wjpj	Камуфляж «DPM Iranian Guard»	item.18223.name	other	RANK_NEWBIE
683	96op0	Камуфляж «DPM Kuwaiti Police»	item.18224.name	other	RANK_STALKER
684	1ry36	Камуфляж «DPM OJ»	item.18225.name	other	RANK_NEWBIE
685	g4z20	Камуфляж «DPM Oman»	item.18226.name	other	RANK_NEWBIE
686	zzn92	Камуфляж «DPM PECOC»	item.18227.name	other	RANK_NEWBIE
687	5ljpg	Камуфляж «DPM Red Desert»	item.18228.name	other	RANK_NEWBIE
688	y36mz	Камуфляж «DPM Urban»	item.18229.name	other	RANK_NEWBIE
689	wjyrp	Камуфляж «DPM Woodland A»	item.18230.name	other	RANK_NEWBIE
690	4qjpp	Камуфляж «DPM Woodland B»	item.18231.name	other	RANK_NEWBIE
691	kn290	Камуфляж «Hexcam Arid»	item.18232.name	other	RANK_NEWBIE
692	qjpw6	Камуфляж «Hexcam Jungle»	item.camo.wpn.hexcam_jungle.name	other	RANK_NEWBIE
693	j5w27	Камуфляж «Hexcam OPFOR»	item.18234.name	other	RANK_NEWBIE
694	lyo1j	Камуфляж «Hexcam Mist»	item.camo.wpn.hexcam_mist.name	other	RANK_NEWBIE
695	rw94g	Камуфляж «VolumeHex Flora»	item.18236.name	other	RANK_NEWBIE
696	0r6pd	Камуфляж «VolumeHex Dune»	item.18237.name	other	RANK_NEWBIE
697	m0ngj	Камуфляж «VolumeHex Wave»	item.18238.name	other	RANK_STALKER
698	ok65o	Камуфляж «VolumeHex Pink»	item.18239.name	other	RANK_MASTER
699	n4o96	Камуфляж «Flecktarn»	item.18240.name	other	RANK_NEWBIE
700	p6og6	Камуфляж «Flecktarn Suburban»	item.18241.name	other	RANK_NEWBIE
701	vj5kn	Камуфляж «Flecktarn Forest»	item.18242.name	other	RANK_NEWBIE
702	dm9w5	Камуфляж «Flecktarn Frost»	item.camo.wpn.flecktarn_frost.name	other	RANK_NEWBIE
703	3g2yz	Трофейный камуфляж «Erbsenmuster»	item.18245.name	other	RANK_STALKER
704	7ldq3	Трофейный камуфляж «Luft Splinter»	item.18246.name	other	RANK_STALKER
705	6wjkj	Трофейный камуфляж «Sumpfmuster» обр. 1943 г.	item.18247.name	other	RANK_STALKER
706	96ol0	Камуфляж «Hexagon-C»	item.18248.name	other	RANK_STALKER
707	1ryz6	Камуфляж «M90 Threat»	item.18249.name	other	RANK_STALKER
708	g4zq0	Камуфляж «M90 Winter»	item.camo.wpn.m90_winter.name	other	RANK_NEWBIE
709	zznr2	Камуфляж «ERDL Winter»	item.camo.wpn.erdl_winter.name	other	RANK_NEWBIE
710	5lj4g	Камуфляж «VolumeHex Flake»	item.camo.wpn.volumehex_flake.name	other	RANK_NEWBIE
711	y36lz	Камуфляж «DPM White»	item.camo.wpn.dpm_white.name	other	RANK_NEWBIE
712	wjyqp	Камуфляж «A-TACS WN»	item.camo.wpn.atacs_wn.name	other	RANK_NEWBIE
713	4qjwp	Камуфляж «Hexcam BX»	item.camo.wpn.hexcam_bx.name	other	RANK_STALKER
714	g4z5g	Краска «Срыв»	item.camo.wpn.bf_skin_1.name	other	RANK_NEWBIE
715	zzn19	Краска «Ярость»	item.camo.wpn.bf_skin_2.name	other	RANK_NEWBIE
716	96ogl	Краска «Красные осколки»	item.camo.wpn.bf_skin_3.name	other	RANK_NEWBIE
717	1ryng	Краска «Розовые осколки»	item.camo.wpn.bf_skin_4.name	other	RANK_NEWBIE
718	g4z56	Краска «Токсичные осколки»	item.camo.wpn.bf_skin_5.name	other	RANK_NEWBIE
719	zzn1y	Краска «Токсичная коррозия»	item.camo.wpn.bf_skin_6.name	other	RANK_NEWBIE
720	5lj21	Краска «Мутировавшая оболочка»	item.camo.wpn.bf_skin_7.name	other	RANK_NEWBIE
721	y369k	Краска «Blufor»	item.camo.wpn.bf_skin_8.name	other	RANK_NEWBIE
722	wjy22	Краска «Кровавый туман»	item.camo.wpn.bf_skin_9.name	other	RANK_NEWBIE
723	4qjdr	Краска «Blood Grid»	item.camo.wpn.bf_skin_10.name	other	RANK_NEWBIE
724	kn24y	Краска «Изумрудный взрыв»	item.camo.wpn.bf_skin_11.name	other	RANK_NEWBIE
725	qjpdj	Краска «Киноварь»	item.camo.wpn.bf_skin_12.name	other	RANK_NEWBIE
726	j5wy0	Краска «Сапфир»	item.camo.wpn.bf_skin_13.name	other	RANK_NEWBIE
727	lyoqk	Краска «Бордовые наросты»	item.camo.wpn.bf_skin_14.name	other	RANK_NEWBIE
728	rw93v	Краска «Сумрачные наросты»	item.camo.wpn.bf_skin_15.name	other	RANK_NEWBIE
729	0r659	Краска «Мутировавшие наросты»	item.camo.wpn.bf_skin_16.name	other	RANK_NEWBIE
730	m0nly	Краска «Красные нити»	item.camo.wpn.bf_skin_17.name	other	RANK_NEWBIE
731	ok6o6	Краска «Синие нити»	item.camo.wpn.bf_skin_18.name	other	RANK_NEWBIE
732	n4o01	Краска «Зеленые нити»	item.camo.wpn.bf_skin_19.name	other	RANK_NEWBIE
733	p6opw	Краска «Фиолетовые нити»	item.camo.wpn.bf_skin_20.name	other	RANK_NEWBIE
734	vj5wr	Краска «Узор хищника»	item.camo.wpn.bf_skin_21.name	other	RANK_NEWBIE
735	dm9nj	Краска «Предостережение»	item.camo.wpn.bf_skin_22.name	other	RANK_NEWBIE
736	2owkl	Краска «Токсичные линии»	item.camo.wpn.bf_skin_23.name	other	RANK_NEWBIE
737	9607l	Скин «Чистое золото»	item.19000.name	other	RANK_MASTER
738	1rmwg	Краска для брони «Красная»	item.camo.arm.red.name	other	RANK_NEWBIE
739	g4j76	Краска для брони «Оранжевая»	item.camo.arm.orange.name	other	RANK_NEWBIE
740	zzvmy	Краска для брони «Желтая»	item.camo.arm.yellow.name	other	RANK_NEWBIE
741	5l0m1	Краска для брони «Зеленая»	item.camo.arm.green.name	other	RANK_NEWBIE
742	y3vrk	Краска для брони «Голубая»	item.camo.arm.blue.name	other	RANK_NEWBIE
743	wjvk2	Краска для брони «Синяя»	item.camo.arm.indigo.name	other	RANK_NEWBIE
744	4qmrr	Краска для брони «Фиолетовая»	item.camo.arm.violet.name	other	RANK_NEWBIE
745	kn1yy	Краска для брони «Черная»	item.camo.arm.black.name	other	RANK_NEWBIE
746	qj4lj	Краска для брони «Белая»	item.camo.arm.white.name	other	RANK_NEWBIE
747	j59p0	Краска для брони «Хаки»	item.camo.arm.sand.name	other	RANK_NEWBIE
748	lygwk	Краска для брони «Оливковая»	item.camo.arm.oliva.name	other	RANK_NEWBIE
749	rwklv	Краска для брони «Коричневая»	item.camo.arm.brown.name	other	RANK_NEWBIE
750	0ryw9	Краска для брони «Мужественный розовый»	item.camo.arm.pink.name	other	RANK_MASTER
751	m0zwy	Краска для брони «Серая»	item.camo.arm.grey.name	other	RANK_NEWBIE
752	9623y	Камуфляж «Бутан»	item.camo.arm.butan.name	other	RANK_NEWBIE
753	1r6o2	Камуфляж «Бутан - Скалистый берег»	item.19101.name	other	RANK_NEWBIE
754	g4wk5	Камуфляж «Березка»	item.19102.name	other	RANK_NEWBIE
755	zz6km	Камуфляж «Сурпат»	item.19103.name	other	RANK_NEWBIE
756	5l7oq	Камуфляж «Сурпат - Городской шум»	item.19104.name	other	RANK_NEWBIE
757	y3on3	Камуфляж «Жаба»	item.19105.name	other	RANK_NEWBIE
758	wjml3	Камуфляж «Жаба - белый»	item.19106.name	other	RANK_NEWBIE
759	4q27o	Камуфляж «Флора»	item.19107.name	other	RANK_NEWBIE
760	kn1pp	Камуфляж «Дюна»	item.19108.name	other	RANK_NEWBIE
761	qj4q3	Камуфляж «Волна»	item.19109.name	other	RANK_NEWBIE
762	j59qg	Камуфляж «Излом»	item.19110.name	other	RANK_NEWBIE
763	lygro	Камуфляж «Скол»	item.19111.name	other	RANK_NEWBIE
764	rwkvy	Камуфляж «Спектр»	item.19112.name	other	RANK_NEWBIE
765	0ryly	Камуфляж «Спектр - почва»	item.19113.name	other	RANK_NEWBIE
766	m0zq2	Камуфляж «Гелетейка»	item.19114.name	other	RANK_NEWBIE
767	okypm	Камуфляж «Городской четырехцветный»	item.19115.name	other	RANK_NEWBIE
768	n45w2	Камуфляж «Русская цифра»	item.19116.name	other	RANK_NEWBIE
769	p6wq4	Камуфляж «Гравий»	item.19117.name	other	RANK_NEWBIE
770	vjm3p	Камуфляж «Березка» обр. 1943 г.	item.19118.name	other	RANK_STALKER
771	dmzy2	Камуфляж «Амеба» обр. 1942 г.	item.19119.name	other	RANK_STALKER
772	2o405	Камуфляж «Пальмовая амеба»	item.19120.name	other	RANK_NEWBIE
773	3gkq5	Камуфляж «Северный склон»	item.19121.name	other	RANK_NEWBIE
774	7l21j	Камуфляж «Хуртовина»	item.camo.arm.geleteika_winter.name	other	RANK_NEWBIE
775	6w290	Камуфляж «Хлопья»	item.camo.arm.flake.name	other	RANK_NEWBIE
776	962zy	Камуфляж «Бутан - Снег»	item.camo.arm.butan_snow.name	other	RANK_NEWBIE
777	1r6l2	Камуфляж «Буря»	item.camo.arm.burya.name	other	RANK_NEWBIE
778	g4w15	Камуфляж «Белорусская цифра»	item.19126.name	other	RANK_NEWBIE
779	zz6wm	Цифровой камуфляж Казахстана	item.19127.name	other	RANK_NEWBIE
780	5l76q	Камуфляж «Поле»	item.camo.arm.field.name	other	RANK_NEWBIE
781	y3o03	Камуфляж «Гряда»	item.camo.arm.gryada.name	other	RANK_STALKER
782	wjm03	Камуфляж «Цифровой тигр»	item.camo.arm.tiger_digital.name	other	RANK_NEWBIE
783	4q25o	Камуфляж «Спад»	item.camo.arm.spad.name	other	RANK_NEWBIE
784	kn15p	Камуфляж «Ельник»	item.camo.arm.fir.name	other	RANK_STALKER
785	9620q	Камуфляж «A-TACS FG»	item.19200.name	other	RANK_NEWBIE
786	1r6mr	Камуфляж «A-TACS AU»	item.19201.name	other	RANK_NEWBIE
787	g4wjn	Камуфляж «Hexagon-A»	item.19202.name	other	RANK_NEWBIE
788	zz6vk	Камуфляж «Hexagon-B»	item.19203.name	other	RANK_NEWBIE
789	5l70o	Камуфляж «Digital-A»	item.19204.name	other	RANK_NEWBIE
790	y3ov0	Камуфляж «Digital-B»	item.19205.name	other	RANK_NEWBIE
791	wjmvz	Камуфляж «Belgian Jigsaw»	item.19206.name	other	RANK_NEWBIE
792	4q2mj	Камуфляж «Belgian Jigsaw Desert»	item.19207.name	other	RANK_NEWBIE
793	kn1jj	Камуфляж «M90»	item.19208.name	other	RANK_NEWBIE
794	qj454	Камуфляж «M90 Night»	item.19209.name	other	RANK_NEWBIE
795	j59jl	Камуфляж «M90 Desert»	item.19210.name	other	RANK_NEWBIE
796	lygp2	Камуфляж «M90 Urban»	item.19211.name	other	RANK_NEWBIE
797	rwkyz	Камуфляж «ERDL ARVN Red»	item.19212.name	other	RANK_NEWBIE
798	0rymk	Камуфляж «ERDL ARVN SV»	item.19213.name	other	RANK_NEWBIE
799	m0z9k	Камуфляж «ERDL ARVN Yellow»	item.19214.name	other	RANK_NEWBIE
800	okyg5	Камуфляж «ERDL Red»	item.19215.name	other	RANK_NEWBIE
801	n4519	Камуфляж «ERDL Stinger»	item.19216.name	other	RANK_NEWBIE
802	p6wzd	Камуфляж «ERDL Streetfighter»	item.19217.name	other	RANK_NEWBIE
803	vjmv7	Камуфляж «ERDL Urban»	item.19218.name	other	RANK_NEWBIE
804	dmz4g	Камуфляж «ERDL USCM»	item.19219.name	other	RANK_NEWBIE
805	2o4mv	Камуфляж «ERDL Woodland»	item.19220.name	other	RANK_NEWBIE
806	3gkm1	Камуфляж «Multicam»	item.19221.name	other	RANK_NEWBIE
807	7l209	Камуфляж «DPM Desert»	item.19222.name	other	RANK_NEWBIE
808	6w2dn	Камуфляж «DPM Iranian Guard»	item.19223.name	other	RANK_NEWBIE
809	9622q	Камуфляж «DPM Kuwaiti Police»	item.19224.name	other	RANK_STALKER
810	1r66r	Камуфляж «DPM OJ»	item.19225.name	other	RANK_NEWBIE
811	g4wwn	Камуфляж «DPM Oman»	item.19226.name	other	RANK_NEWBIE
812	zz66k	Камуфляж «DPM PECOC»	item.19227.name	other	RANK_NEWBIE
813	5l77o	Камуфляж «DPM Red Desert»	item.19228.name	other	RANK_NEWBIE
814	y3oo0	Камуфляж «DPM Urban»	item.19229.name	other	RANK_NEWBIE
815	wjmmz	Камуфляж «DPM Woodland A»	item.19230.name	other	RANK_NEWBIE
816	4q22j	Камуфляж «DPM Woodland B»	item.19231.name	other	RANK_NEWBIE
817	kn11j	Камуфляж «Hexcam Arid»	item.19232.name	other	RANK_NEWBIE
818	qj444	Камуфляж «Hexcam Jungle»	item.camo.arm.hexcam_jungle.name	other	RANK_NEWBIE
819	j599l	Камуфляж «Hexcam OPFOR»	item.19234.name	other	RANK_NEWBIE
820	lygg2	Камуфляж «Hexcam Mist»	item.camo.arm.hexcam_mist.name	other	RANK_NEWBIE
821	rwkkz	Камуфляж «VolumeHex Flora»	item.19236.name	other	RANK_NEWBIE
822	0ryyk	Камуфляж «VolumeHex Dune»	item.19237.name	other	RANK_NEWBIE
823	m0zzk	Камуфляж «VolumeHex Wave»	item.19238.name	other	RANK_STALKER
824	okyy5	Камуфляж «VolumeHex Pink»	item.19239.name	other	RANK_MASTER
825	n4559	Камуфляж «Flecktarn»	item.19240.name	other	RANK_NEWBIE
826	p6wwd	Камуфляж «Flecktarn Suburban»	item.19241.name	other	RANK_NEWBIE
827	vjmm7	Камуфляж «Flecktarn Forest»	item.19242.name	other	RANK_NEWBIE
828	dmzzg	Камуфляж «Flecktarn Frost»	item.camo.arm.flecktarn_frost.name	other	RANK_NEWBIE
829	3gkk1	Трофейный камуфляж «Erbsenmuster»	item.19245.name	other	RANK_STALKER
830	7l229	Трофейный камуфляж «Luft Splinter»	item.19246.name	other	RANK_STALKER
831	6w22n	Трофейный камуфляж «Sumpfmuster» обр. 1943 г.	item.19247.name	other	RANK_STALKER
832	962mq	Камуфляж «Hexagon-C»	item.19248.name	other	RANK_STALKER
833	1r6dr	Камуфляж «M90 Threat»	item.19249.name	other	RANK_STALKER
834	g4w0n	Камуфляж «M90 Winter»	item.camo.arm.m90_winter.name	other	RANK_NEWBIE
835	zz67k	Камуфляж «ERDL Winter»	item.camo.arm.erdl_winter.name	other	RANK_NEWBIE
836	5l7do	Камуфляж «VolumeHex Flake»	item.camo.arm.volumehex_flake.name	other	RANK_NEWBIE
837	y3o70	Камуфляж «DPM White»	item.camo.arm.dpm_white.name	other	RANK_NEWBIE
838	wjmoz	Камуфляж «A-TACS WN»	item.camo.arm.atacs_wn.name	other	RANK_NEWBIE
839	4q20j	Камуфляж «Hexcam BX»	item.camo.arm.hexcam_bx.name	other	RANK_STALKER
840	g4wqp	Краска «Срыв»	item.camo.arm.bf_skin_1.name	other	RANK_NEWBIE
841	zz6rn	Краска «Ярость»	item.camo.arm.bf_skin_2.name	other	RANK_NEWBIE
842	962l0	Краска «Красные осколки»	item.camo.arm.bf_skin_3.name	other	RANK_NEWBIE
843	1r6z6	Краска «Розовые осколки»	item.camo.arm.bf_skin_4.name	other	RANK_NEWBIE
844	g4wq0	Краска «Токсичные осколки»	item.camo.arm.bf_skin_5.name	other	RANK_NEWBIE
845	zz6r2	Краска «Токсичная коррозия»	item.camo.arm.bf_skin_6.name	other	RANK_NEWBIE
846	5l74g	Краска «Мутировавшая оболочка»	item.camo.arm.bf_skin_7.name	other	RANK_NEWBIE
847	y3olz	Краска «Blufor»	item.camo.arm.bf_skin_8.name	other	RANK_NEWBIE
848	wjmqp	Краска «Кровавый туман»	item.camo.arm.bf_skin_9.name	other	RANK_NEWBIE
849	4q2wp	Краска «Blood Grid»	item.camo.arm.bf_skin_10.name	other	RANK_NEWBIE
850	kn100	Краска «Изумрудный взрыв»	item.camo.arm.bf_skin_11.name	other	RANK_NEWBIE
851	qj4z6	Краска «Киноварь»	item.camo.arm.bf_skin_12.name	other	RANK_NEWBIE
852	j59r7	Краска «Сапфир»	item.camo.arm.bf_skin_13.name	other	RANK_NEWBIE
853	lygmj	Краска «Бордовые наросты»	item.camo.arm.bf_skin_14.name	other	RANK_NEWBIE
854	rwk5g	Краска «Сумрачные наросты»	item.camo.arm.bf_skin_15.name	other	RANK_NEWBIE
855	0rygd	Краска «Мутировавшие наросты»	item.camo.arm.bf_skin_16.name	other	RANK_NEWBIE
856	m0zoj	Краска «Красные нити»	item.camo.arm.bf_skin_17.name	other	RANK_NEWBIE
857	oky1o	Краска «Синие нити»	item.camo.arm.bf_skin_18.name	other	RANK_NEWBIE
858	n45d6	Краска «Зеленые нити»	item.camo.arm.bf_skin_19.name	other	RANK_NEWBIE
859	p6wd6	Краска «Фиолетовые нити»	item.camo.arm.bf_skin_20.name	other	RANK_NEWBIE
860	vjmzn	Краска «Узор хищника»	item.camo.arm.bf_skin_21.name	other	RANK_NEWBIE
861	dmzd5	Краска «Предостережение»	item.camo.arm.bf_skin_22.name	other	RANK_NEWBIE
862	2o4z0	Краска «Токсичные линии»	item.camo.arm.bf_skin_23.name	other	RANK_NEWBIE
863	962yw	«БУЛЬДОЗЕР»	item.camo.unique_arm.buldozer.name	other	DEFAULT
864	1r6pq	«Прототип»	item.camo.unique_arm.prototype.name	other	DEFAULT
865	g4w3g	«Пожарный»	item.camo.unique_arm.fireman.name	other	DEFAULT
866	zz6j9	«Мехатроника»	item.camo.unique_arm.mehatronika.name	other	DEFAULT
867	5l714	«Полураспад»	item.camo.unique_arm.halflive.name	other	DEFAULT
868	y3oqw	«Mark V»	item.camo.unique_arm.markv.name	other	DEFAULT
869	wjm4d	«Железяка»	item.camo.unique_arm.iron.name	other	DEFAULT
870	4q29l	«МИР»	item.camo.unique_arm.world.name	other	DEFAULT
871	kn133	«АBS380»	item.camo.unique_arm.abs382.name	other	DEFAULT
872	qj419	«Цельнометаллический»	item.camo.unique_arm.fullmetal.name	other	DEFAULT
873	j5934	«USS-01»	item.camo.unique_arm.uss.name	other	DEFAULT
874	lyg3q	«Легенда»	item.camo.unique_arm.legend.name	other	DEFAULT
875	rwk1l	«Магмовый воин»	item.camo.unique_arm.magma_warrior.name	other	DEFAULT
876	0rydr	«Капеллан»	item.camo.unique_arm.kapellan.name	other	DEFAULT
877	m0zpr	«Взрыв красок»	item.camo.unique_arm.paint.name	other	DEFAULT
878	okyd4	«Печь»	item.camo.unique_arm.bake.name	other	DEFAULT
879	n45vw	«Псих»	item.camo.unique_arm.neon.name	other	DEFAULT
880	p6w25	«HABOLOG»	item.camo.unique_arm.habolog.name	other	DEFAULT
881	vjmyg	«Spectre»	item.camo.unique_arm.spectre.name	other	DEFAULT
882	dmzk9	«Грешник»	item.camo.unique_arm.sinner.name	other	DEFAULT
883	2o49m	«Агент»	item.camo.unique_arm.agent.name	other	DEFAULT
884	3gk1k	«Один»	item.camo.unique_arm.odin.name	other	DEFAULT
885	7l2yr	«Архангел»	item.camo.unique_arm.archangel.name	other	DEFAULT
886	6w256	«Ланцелот»	item.camo.unique_arm.lancelot.name	other	DEFAULT
887	9624w	«Кэрри»	item.camo.unique_arm.carry.name	other	DEFAULT
888	1r62q	«Мертвый анархист»	item.camo.unique_arm.dead.name	other	DEFAULT
889	g4wlg	«Ликвидатор»	item.camo.unique_arm.likvidator.name	other	DEFAULT
890	zz6q9	«Hell Rider»	item.camo.unique_arm.hellrider.name	other	DEFAULT
891	5l7z4	«Одноглазый Джо»	item.camo.unique_arm.joe.name	other	DEFAULT
892	y3okw	«Меркурий»	item.camo.unique_arm.mercury.name	other	DEFAULT
893	wjmwd	«Магистр рун»	item.camo.unique_arm.runemaster.name	other	DEFAULT
894	4q2gl	«Изгой»	item.camo.unique_arm.outlaw.name	other	DEFAULT
895	kn1o3	«Отрекшийся»	item.camo.unique_arm.forsworn.name	other	DEFAULT
896	qj499	«Анархист»	item.camo.unique_arm.anarchy.name	other	DEFAULT
897	j59m4	«Модификация 47»	item.camo.unique_arm.mod47.name	other	DEFAULT
898	lygnq	«Хранитель»	item.camo.unique_arm.guardian.name	other	DEFAULT
899	rwkol	«Леший»	item.camo.unique_arm.goblin.name	other	DEFAULT
900	0ryor	«Истязающий»	item.camo.unique_arm.mourner.name	other	DEFAULT
901	m0zjr	«Хранитель Оазиса»	item.camo.unique_arm.oazis.name	other	DEFAULT
902	n45lw	«Спецохрана»	item.camo.unique_arm.guard1.name	other	DEFAULT
903	p6w05	«Спецохрана»	item.camo.unique_arm.guard2.name	other	DEFAULT
904	vjmdg	«Пророк»	item.camo.unique_arm.prorok.name	other	DEFAULT
905	dmz19	«Арктика»	item.camo.unique_arm.arctica.name	other	DEFAULT
906	7l29r	«Головорез»	item.camo.unique_arm.thug_ratcatcher.name	other	DEFAULT
907	6w236	«Рейдер»	item.camo.unique_arm.raider_armai.name	other	DEFAULT
908	962gw	«Морозоборец»	item.camo.unique_arm.frostfighter.name	other	DEFAULT
909	wjm2d	«Сверхзвуковой»	item.camo.unique_arm.supersonic.name	other	DEFAULT
910	4q2dl	«III-B»	item.camo.unique_arm.bbb.name	other	DEFAULT
911	kn1k3	«Спецтехника»	item.camo.unique_arm.build.name	other	DEFAULT
912	qj4m9	«Стальной охотник»	item.camo.unique_arm.hunt.name	other	DEFAULT
913	j5944	«Перерожденный»	item.camo.unique_arm.hw22.name	other	DEFAULT
914	lyg6q	«Лич»	item.camo.unique_arm.lich.name	other	DEFAULT
915	rwk3l	«Утечка криогена»	item.camo.unique_arm.ao5_blizzard23.name	other	DEFAULT
916	0ry5r	«Холодная голова»	item.camo.unique_arm.skat_blizzard23.name	other	DEFAULT
917	m0zlr	«Закаленный в боях»	item.camo.unique_arm.ravent23.name	other	DEFAULT
918	okyo4	«Любимчик Тренера»	item.camo.unique_arm.ao5_halloween23.name	other	DEFAULT
919	n450w	«Марафонец»	item.camo.unique_arm.halloween23.name	other	DEFAULT
920	96m2q	«Драгоценность Оазиса»	item.19800.name	other	DEFAULT
921	1rd6r	«Адское пекло»	item.19801.name	other	DEFAULT
922	g40wn	«Легенда»	item.19802.name	other	DEFAULT
923	zz76k	«Черная роза»	item.19803.name	other	DEFAULT
924	5ld7o	«Коллекционер»	item.19804.name	other	DEFAULT
925	y37o0	«Сосна»	item.19805.name	other	DEFAULT
926	wjomz	«Растаман»	item.19806.name	other	DEFAULT
927	4q02j	«Red Autumn»	item.19807.name	other	DEFAULT
928	lylg2	«Самодел»	item.19811.name	other	DEFAULT
929	rwrkz	«Накал»	item.19812.name	other	DEFAULT
930	vjrm7	«УЗ»	item.19818.name	other	DEFAULT
931	dmqzg	«Износ»	item.19819.name	other	DEFAULT
932	2od4v	«Тестовый образец» ОЦ-33	item.19820.name	other	DEFAULT
933	3grk1	«Тестовый образец» РМО-93	item.19821.name	other	DEFAULT
934	7lr29	«Тестовый образец» ТКБ-0146М	item.19822.name	other	DEFAULT
935	6wr2n	«Тестовый образец» РПК-16	item.19823.name	other	DEFAULT
936	1rddr	«Головорез» ОТЛ-3	item.19825.name	other	DEFAULT
937	g400n	«Головорез» ОЦ-62	item.19826.name	other	DEFAULT
938	5lddo	«Морозный tigor» ОЦ-33	item.19828.name	other	DEFAULT
939	y3770	«Хренорезка»	item.camo.unique_wpn.hrenorezka_flamepistol.name	other	DEFAULT
940	wjooz	«Хренострел»	item.camo.unique_wpn.hrenostrel_fg42.name	other	DEFAULT
941	4q00j	«Токсин»	item.camo.unique_wpn.alk22_toxin.name	other	DEFAULT
942	knlgv	«Лимб»	item.mtl.wpn.lim.name	other/skins	RANK_MASTER
943	96mj0	ПП-91 «Кедр»	item.wpn.kedr.name	weapon/submachine_gun	RANK_NEWBIE
944	1rdg6	HK MP5	item.wpn.mp5.name	weapon/submachine_gun	RANK_VETERAN
945	g40d0	IMI Uzi	item.wpn.uzi.name	weapon/submachine_gun	RANK_NEWBIE
946	zz742	АЕК-919К «Каштан»	item.wpn.kashtan.name	weapon/submachine_gun	RANK_STALKER
947	5ldwg	АКС-74У	item.wpn.aksu.name	weapon/assault_rifle	DEFAULT
948	y37wz	Walther MPK	item.wpn.mpk.name	weapon/submachine_gun	DEFAULT
949	m02dj	Vz.68 Scorpion	item.wpn.vz68.name	weapon/submachine_gun	RANK_NEWBIE
950	okv2o	«Гепард»	item.wpn.gepard.name	weapon/submachine_gun	RANK_NEWBIE
951	n4p76	HK UMP45	item.wpn.ump45.name	weapon/submachine_gun	RANK_VETERAN
952	p6r76	«Витязь-СН»	item.wpn.vityaz_sn.name	weapon/submachine_gun	RANK_VETERAN
953	vjr7n	Beretta Mx4 Storm	item.wpn.mx4.name	weapon/submachine_gun	RANK_VETERAN
954	dmq75	ППК-20	item.wpn.ppk20.name	weapon/submachine_gun	RANK_MASTER
955	2ody0	ОЦ-14-А1 «Тор»	item.wpn.ots14a1.name	weapon/assault_rifle	RANK_VETERAN
956	3grwz	PSA PA 10 «Такт»	item.wpn.tact.name	weapon/assault_rifle	RANK_VETERAN
957	7lrj3	АКС-9 «Горностай»	item.wpn.gornostay.name	weapon/assault_rifle	RANK_VETERAN
958	1rd56	АКС-74	item.wpn.aks74.name	weapon/assault_rifle	RANK_NEWBIE
959	g4060	L85A1	item.wpn.l85.name	weapon/assault_rifle	RANK_VETERAN
960	zz7d2	ПП-19 «Бизон-2-01»	item.wpn.bizon.name	weapon/submachine_gun	RANK_VETERAN
961	5ldkg	АКМ	item.wpn.akm.name	weapon/assault_rifle	RANK_STALKER
962	y37dz	ПП-19-01 «Витязь»	item.wpn.vityaz.name	weapon/submachine_gun	RANK_VETERAN
963	knl70	АКС чистильщика	item.wpn.aks74_main.name	weapon/assault_rifle	RANK_NEWBIE
964	j5l77	Поношенная L85A1	item.wpn.l85-1.name	weapon/assault_rifle	RANK_STALKER
965	lyl7j	M16A1	item.wpn.m16a1.name	weapon/assault_rifle	DEFAULT
966	okv7o	АН-94 «Абакан»	item.wpn.abakan-05.name	weapon/assault_rifle	RANK_STALKER
967	p6rm6	ППШ	item.wpn.ppsh41.name	weapon/submachine_gun	RANK_STALKER
968	vjr1n	АК-74М	item.wpn.ak74m.name	weapon/assault_rifle	RANK_NEWBIE
969	dmqg5	АКМ «Тишина»	item.wpn.akmb.name	weapon/assault_rifle	RANK_VETERAN
970	2odq0	АК-203	item.wpn.ak203.name	weapon/assault_rifle	RANK_VETERAN
971	3gr6z	LWRC M6	item.wpn.lwrc.name	weapon/assault_rifle	RANK_VETERAN
972	7lrm3	Старый FN FAL	item.wpn.fal_old.name	weapon/assault_rifle	RANK_VETERAN
973	6wr0j	АЕК-973 «Марс»	item.wpn.aek973.name	weapon/assault_rifle	RANK_VETERAN
974	96mn0	PSA PA 10 «Ритм»	item.wpn.rhythm.name	weapon/assault_rifle	RANK_VETERAN
975	1rdk6	АК-9М «Койот»	item.wpn.akm9.name	weapon/assault_rifle	RANK_VETERAN
976	zz7y2	M4A1	item.wpn.m4.name	weapon/assault_rifle	RANK_STALKER
977	5ldrg	FN P90	item.wpn.p90.name	weapon/submachine_gun	RANK_VETERAN
978	y375z	АС «Вал»	item.wpn.val.name	weapon/assault_rifle	RANK_VETERAN
979	wjogp	SIG SG 550	item.wpn.sig.name	weapon/assault_rifle	RANK_VETERAN
980	4q0lp	ПП-2000	item.wpn.pp2000.name	weapon/submachine_gun	RANK_STALKER
981	knlq0	СР-2М «Вереск»	item.wpn.sr2.name	weapon/submachine_gun	RANK_VETERAN
982	qjvo6	Spectre M4	item.wpn.spectre.name	weapon/submachine_gun	RANK_STALKER
983	j5lk7	M16A3	item.wpn.m16a3.name	weapon/assault_rifle	RANK_NEWBIE
984	lyljj	M4 LB	item.wpn.m4_lb.name	weapon/assault_rifle	RANK_VETERAN
985	rwrng	АН-94М «Абакан»	item.wpn.abakan.name	weapon/assault_rifle	RANK_VETERAN
986	okv0o	M16A2	item.wpn.m16a2.name	weapon/assault_rifle	RANK_NEWBIE
987	3grdz	СР-3 «Вихрь»	item.wpn.sr3.name	weapon/submachine_gun	RANK_VETERAN
988	7lrz3	АК-103	item.wpn.ak103.name	weapon/assault_rifle	RANK_VETERAN
989	96my0	АЛК-22 «Стрекоза»	item.wpn.alk22.name	weapon/assault_rifle	RANK_VETERAN
990	zz7j2	HK G36C	item.wpn.g36c.name	weapon/assault_rifle	RANK_VETERAN
991	5ld1g	ОЦ-14 «Гроза»	item.wpn.groza.name	weapon/assault_rifle	RANK_VETERAN
992	y37qz	TDI KRISS Vector	item.wpn.kriss.name	weapon/submachine_gun	RANK_MASTER
993	wjo4p	А-545	item.wpn.a545.name	weapon/assault_rifle	RANK_MASTER
994	4q09p	HK G3A1	item.wpn.g3a1.name	weapon/assault_rifle	RANK_VETERAN
995	knl30	FN F2000 Tactical	item.wpn.f2000.name	weapon/assault_rifle	RANK_MASTER
996	j5l37	АЕК-971	item.wpn.aek971.name	weapon/assault_rifle	RANK_VETERAN
997	lyl3j	АШ-12	item.wpn.ash12.name	weapon/assault_rifle	RANK_MASTER
998	0r3nd	Поношенная HK G3A1	item.wpn.g3a1-1.name	weapon/assault_rifle	RANK_VETERAN
999	m023j	Поношенный SIG SG 550	item.wpn.sig-1.name	weapon/assault_rifle	RANK_STALKER
1000	p6r26	FN F2000	item.wpn.f2000-1.name	weapon/assault_rifle	RANK_VETERAN
1001	vjryn	СР-3М	item.wpn.sr3m.name	weapon/submachine_gun	RANK_MASTER
1002	dmqk5	АМ-17	item.wpn.am17.name	weapon/assault_rifle	RANK_MASTER
1003	2od90	Scorpion EVO III	item.wpn.scorpion.name	weapon/submachine_gun	RANK_MASTER
1004	3gr1z	SIG MPX	item.wpn.mpx.name	weapon/submachine_gun	RANK_VETERAN
1005	7lry3	АМБ-17	item.wpn.amb17.name	weapon/assault_rifle	RANK_MASTER
1006	6wr5j	АК-15	item.wpn.ak15.name	weapon/assault_rifle	RANK_MASTER
1007	zz7q2	Steyr AUG A3 9mm XS	item.wpn.aug9xs.name	weapon/submachine_gun	RANK_VETERAN
1008	96m4w	QBZ-191 «Буревестник»	item.wpn.qbz191.name	weapon/assault_rifle	RANK_MASTER
1009	zz7q9	ОЦ-14М «Разряд»	item.wpn.ots14m.name	weapon/assault_rifle	RANK_MASTER
1010	5ldz4	А-762 «Арес»	item.wpn.a762.name	weapon/assault_rifle	RANK_MASTER
1011	y37kw	PSA 20 STR «Пульс»	item.wpn.pulse.name	weapon/assault_rifle	RANK_MASTER
1012	wjowd	АСМ «Сервал»	item.wpn.valm.name	weapon/assault_rifle	RANK_MASTER
1013	4q0gl	MK47 Mutant	item.wpn.mk47.name	weapon/assault_rifle	RANK_MASTER
1014	knlo3	SIG 516	item.wpn.sig516.name	weapon/assault_rifle	RANK_VETERAN
1015	qjv99	KS-1	item.wpn.ks1.name	weapon/assault_rifle	RANK_MASTER
1016	j5lm4	Beretta ARX-160	item.wpn.arx160.name	weapon/assault_rifle	RANK_MASTER
1017	lylnq	HK MP7A2	item.wpn.mp7.name	weapon/submachine_gun	RANK_MASTER
1018	1rdnq	ДП	item.wpn.dp.name	weapon/machine_gun	RANK_NEWBIE
1019	g405g	РПК-74	item.wpn.rpk74.name	weapon/machine_gun	RANK_VETERAN
1020	g407g	L86A1	item.wpn.l86.name	weapon/machine_gun	RANK_VETERAN
1021	zz7m9	РПД	item.wpn.rpd.name	weapon/machine_gun	RANK_VETERAN
1022	4q0rl	Поношенный ПКП	item.wpn.pkp-1.name	weapon/machine_gun	RANK_VETERAN
1023	knl43	Поношенная L86A1	item.wpn.l86-1.name	weapon/machine_gun	RANK_STALKER
1024	zz2g9	ПКП «Печенег»	item.wpn.pkp.name	weapon/machine_gun	RANK_MASTER
1025	5lnq4	MG 3	item.wpn.mg3.name	weapon/machine_gun	RANK_MASTER
1026	wj7nd	РПЛ-20	item.wpn.rpl20.name	weapon/machine_gun	RANK_MASTER
1027	4qnzl	6П62 «Малыш»	item.wpn.6p62.name	weapon/machine_gun	RANK_MASTER
1028	1r7rg	Карабин Мосина	item.wpn.mosinkar.name	weapon/sniper_rifle	DEFAULT
1029	g4m46	СКС	item.wpn.sks.name	weapon/sniper_rifle	RANK_NEWBIE
1030	1r79g	СКТ-40	item.wpn.skt40.name	weapon/sniper_rifle	RANK_NEWBIE
1031	g4mn6	Winchester M70	item.wpn.winchester.name	weapon/sniper_rifle	RANK_STALKER
1032	zz23y	Поношенный Winchester M70	item.wpn.winchester-1.name	weapon/sniper_rifle	RANK_NEWBIE
1033	wj732	СВТ-40	item.wpn.svt40.name	weapon/sniper_rifle	RANK_STALKER
1034	4qnkr	Steyr Scout	item.wpn.scout.name	weapon/sniper_rifle	RANK_STALKER
1035	knm6y	Mauser 98k	item.wpn.mauser98.name	weapon/sniper_rifle	RANK_NEWBIE
1036	qj2yj	СКС-Т	item.wpn.skst.name	weapon/sniper_rifle	RANK_STALKER
1037	g4mk6	СВД	item.wpn.svd.name	weapon/sniper_rifle	RANK_VETERAN
1038	zz2ky	ВСС-М «Винторез»	item.wpn.vssm.name	weapon/sniper_rifle	RANK_MASTER
1039	5lny1	M40A5	item.wpn.m40.name	weapon/sniper_rifle	RANK_VETERAN
1040	y32gk	Поношенная M40A5	item.wpn.m40-1.name	weapon/sniper_rifle	RANK_VETERAN
1041	wj792	Alpine TPG-1	item.wpn.alpine.name	weapon/sniper_rifle	RANK_VETERAN
1042	knmpy	ВСС «Винторез»	item.wpn.vss.name	weapon/sniper_rifle	RANK_VETERAN
1043	j5oq0	FG-42 «Хлыст»	item.wpn.fg42.name	weapon/sniper_rifle	RANK_VETERAN
1044	ly2rk	МЦ-558	item.wpn.mc558.name	weapon/sniper_rifle	RANK_VETERAN
1045	rw2vv	СВД-С	item.wpn.svds.name	weapon/sniper_rifle	RANK_VETERAN
1046	zz2wy	M1A FA	item.wpn.m1a.name	weapon/sniper_rifle	RANK_VETERAN
1047	5lno1	СВУ	item.wpn.svu.name	weapon/sniper_rifle	RANK_VETERAN
1048	y32nk	WA2000	item.wpn.wa2000.name	weapon/sniper_rifle	RANK_MASTER
1049	wj7l2	L96A1	item.wpn.l96.name	weapon/sniper_rifle	RANK_MASTER
1050	4qn7r	CR-380	item.wpn.cr380.name	weapon/sniper_rifle	RANK_LEGEND
1051	knm5y	M1A	item.wpn.m1a-1.name	weapon/sniper_rifle	RANK_VETERAN
1052	qj23j	ВССК «Выхлоп»	item.wpn.vyhlop.name	weapon/sniper_rifle	RANK_MASTER
1053	rw26v	ОТЛ-03 «Карбач»	item.wpn.otl.name	weapon/sniper_rifle	RANK_MASTER
1054	p635w	Mk 14 EBR	item.wpn.mk14ebr.name	weapon/sniper_rifle	RANK_MASTER
1055	vj20r	СВД-М	item.wpn.svdm.name	weapon/sniper_rifle	RANK_MASTER
1056	dmj6j	СВЧ	item.wpn.svch.name	weapon/sniper_rifle	RANK_MASTER
1057	2ongl	Cheytac M300	item.wpn.cheytac300.name	weapon/sniper_rifle	RANK_MASTER
1058	3gnzl	QBU-191	item.wpn.qbu191.name	weapon/sniper_rifle	RANK_MASTER
1059	969ky	Обрез БМ-16	item.wpn.obrezbm16.name	weapon/shotgun_rifle	DEFAULT
1060	1r742	БМ-16	item.wpn.bm16.name	weapon/shotgun_rifle	DEFAULT
1061	g4mz5	ТОЗ-34	item.wpn.toz.name	weapon/shotgun_rifle	RANK_NEWBIE
1062	zz2nm	Mossberg 590A1	item.wpn.mossberg.name	weapon/shotgun_rifle	RANK_NEWBIE
1063	5ln0q	Shorty 590	item.wpn.shorty.name	weapon/shotgun_rifle	RANK_NEWBIE
1064	y32v3	МР-133	item.wpn.mr133.name	weapon/shotgun_rifle	RANK_NEWBIE
1065	wj7v3	РМО-93	item.wpn.rmo93.name	weapon/shotgun_rifle	RANK_VETERAN
1066	qj253	Chiappa Triple Crown	item.wpn.triple.name	weapon/shotgun_rifle	RANK_VETERAN
1067	zz2vm	Franchi SPAS-12	item.wpn.spas.name	weapon/shotgun_rifle	RANK_STALKER
1068	5ln7q	Сайга-12К	item.wpn.saiga.name	weapon/shotgun_rifle	RANK_VETERAN
1069	y32o3	МР-153	item.wpn.mr153.name	weapon/shotgun_rifle	RANK_STALKER
1070	4qn2o	Protecta	item.wpn.protecta.name	weapon/shotgun_rifle	RANK_VETERAN
1071	j5o9g	ОЦ-62	item.wpn.ots62.name	weapon/shotgun_rifle	RANK_VETERAN
1072	rw2ky	МЦ-255	item.wpn.mts255.name	weapon/shotgun_rifle	RANK_VETERAN
1073	m0mz2	M1014 Breacher	item.wpn.m1014_breacher.name	weapon/shotgun_rifle	RANK_VETERAN
1074	p63w4	Derya MK-12 AS-103S	item.wpn.mk12.name	weapon/shotgun_rifle	RANK_MASTER
1075	vj2mp	KS-12 Komrad	item.wpn.ks12.name	weapon/shotgun_rifle	RANK_MASTER
1076	dmjz2	Pancor Jackhammer	item.wpn.jackhammer.name	weapon/shotgun_rifle	RANK_MASTER
1077	969mq	ПБ	item.wpn.pb.name	weapon/pistol	DEFAULT
1078	1r7dr	ПМ	item.wpn.pm.name	weapon/pistol	DEFAULT
1079	g4m0n	ТТ	item.wpn.tt.name	weapon/pistol	RANK_NEWBIE
1080	1r77r	Форт-12	item.wpn.fort12.name	weapon/pistol	RANK_STALKER
1081	g4mmn	Walther P99	item.wpn.p99.name	weapon/pistol	RANK_STALKER
1082	zz22k	Р-92	item.wpn.r92.name	weapon/pistol	DEFAULT
1083	g4mvn	Beretta 92FS	item.wpn.beretta.name	weapon/pistol	RANK_VETERAN
1084	zz2lk	Browning Hi-Power	item.wpn.hp.name	weapon/pistol	RANK_STALKER
1085	5lngo	Mauser C96	item.wpn.mauser.name	weapon/pistol	RANK_STALKER
1086	y32j0	Beretta 93R	item.wpn.beretta93.name	weapon/pistol	RANK_VETERAN
1087	j5ovl	Поношенный Colt Python	item.wpn.python-1.name	weapon/pistol	RANK_VETERAN
1088	ly2v2	Desert Eagle Mark VII	item.wpn.deagle7.name	weapon/pistol	RANK_VETERAN
1089	rw2zz	СР-1-10	item.wpn.sr1-10.name	weapon/pistol	RANK_VETERAN
1090	0r2qk	«Highest power»	item.wpn.highest_power.name	weapon/pistol	RANK_VETERAN
1091	m0mvk	«Смессон»	item.wpn.smesson.name	weapon/pistol	RANK_VETERAN
1092	zz25k	SW1911	item.wpn.colt.name	weapon/pistol	RANK_VETERAN
1093	5ln9o	Glock 17	item.wpn.glock17.name	weapon/pistol	RANK_VETERAN
1094	y32z0	Desert Eagle Mark XIX	item.wpn.deagle.name	weapon/pistol	RANK_MASTER
1095	wj71z	СР-1 «Гюрза»	item.wpn.sr1.name	weapon/pistol	RANK_VETERAN
1096	4qn6j	ОЦ-33 «Пернач»	item.wpn.oc33.name	weapon/pistol	RANK_MASTER
1097	knmgj	Colt Python	item.wpn.python.name	weapon/pistol	RANK_VETERAN
1098	ly2z2	РШ-12	item.wpn.rsh12.name	weapon/pistol	RANK_MASTER
1099	m0m5k	SIG Sauer P320	item.wpn.p320.name	weapon/pistol	RANK_MASTER
1100	vj297	Glock 18X	item.wpn.glock18x.name	weapon/pistol	RANK_MASTER
1101	dmjog	Cobra Two-Tone	item.wpn.cobra_tt.name	weapon/pistol	RANK_VETERAN
1102	2onjv	Tec-DC9	item.wpn.tec9.name	weapon/pistol	RANK_VETERAN
1103	969vz	HK UMP9	item.wpn.ump.name	weapon/submachine_gun	RANK_STALKER
1104	1r7v1	IMI Mini Uzi	item.wpn.miniuzi.name	weapon/submachine_gun	RANK_STALKER
1105	g4mgp	IMI Micro Uzi	item.wpn.microuzi.name	weapon/pistol	RANK_STALKER
1106	zz2pn	ПММ	item.wpn.pmm.name	weapon/pistol	RANK_STALKER
1107	5lnv0	HK MP5K	item.wpn.mp5k.name	weapon/submachine_gun	RANK_STALKER
1108	y32po	Ingram MAC-10	item.wpn.mac10.name	weapon/pistol	RANK_STALKER
1109	1r731	Kbk wz. 88 Tantal	item.wpn.wz88.name	weapon/assault_rifle	RANK_STALKER
1110	g4m2p	Винтовка Мосина	item.wpn.mosin.name	weapon/sniper_rifle	RANK_NEWBIE
1111	zz29n	Cobray Terminator	item.wpn.terminator.name	weapon/shotgun_rifle	RANK_STALKER
1112	5lnp0	СОК-94	item.wpn.sok94.name	weapon/sniper_rifle	RANK_STALKER
1113	g4mqp	АПС	item.wpn.aps.name	weapon/pistol	RANK_STALKER
1114	zz2rn	АК-105	item.wpn.ak105.name	weapon/assault_rifle	RANK_STALKER
1115	5ln40	LR-300	item.wpn.lr300.name	weapon/assault_rifle	RANK_MASTER
1116	y32lo	FN SCAR-L	item.wpn.scarl.name	weapon/assault_rifle	RANK_STALKER
1117	wj7qo	РПК	item.wpn.rpk.name	weapon/machine_gun	RANK_VETERAN
1118	4qnwn	ОЦ-14М «Ураган»	item.wpn.storm.name	weapon/assault_rifle	RANK_VETERAN
1119	knm0v	СВ-98	item.wpn.sv98.name	weapon/sniper_rifle	RANK_VETERAN
1120	qj2zk	AA-12	item.wpn.aa12.name	weapon/shotgun_rifle	RANK_MASTER
1121	j5or6	Glock 18C	item.wpn.glock18c.name	weapon/pistol	RANK_VETERAN
1122	ly2m1	M1014	item.wpn.m1014.name	weapon/shotgun_rifle	RANK_STALKER
1123	rw255	M249 SAW	item.wpn.m249.name	weapon/machine_gun	RANK_VETERAN
1124	0r2g1	9А-91	item.wpn.9a91.name	weapon/assault_rifle	RANK_VETERAN
1125	m0mo7	ВСК-94	item.wpn.vsk94.name	weapon/sniper_rifle	RANK_MASTER
1126	okm10	Steyr AUG 9mm	item.wpn.aug9mm.name	weapon/submachine_gun	RANK_VETERAN
1127	n4m93	МР-412	item.wpn.mr412.name	weapon/pistol	RANK_VETERAN
1128	p63g2	Steyr AUG A1	item.wpn.aug.name	weapon/assault_rifle	RANK_VETERAN
1129	dmjwn	HK416	item.wpn.hk416.name	weapon/assault_rifle	RANK_VETERAN
1130	2onz6	РПК-16	item.wpn.rpk16.name	weapon/machine_gun	RANK_VETERAN
1131	3gn5g	ТКБ-0146М	item.wpn.tkb.name	weapon/assault_rifle	RANK_VETERAN
1132	7lnk7	МЦ-116М	item.wpn.mc116.name	weapon/sniper_rifle	RANK_VETERAN
1133	6w64y	Grizzly 8.5	item.wpn.grizzly.name	weapon/shotgun_rifle	RANK_VETERAN
1134	969jz	Steyr AUG A2	item.wpn.aug2.name	weapon/assault_rifle	RANK_VETERAN
1135	1r7g1	Steyr AUG A3	item.wpn.aug3.name	weapon/assault_rifle	RANK_VETERAN
1136	g4mdp	АК-12	item.wpn.ak12.name	weapon/assault_rifle	RANK_VETERAN
1137	zz24n	SIG SG 550 Sniper	item.wpn.sigsniper.name	weapon/sniper_rifle	RANK_VETERAN
1138	5lnw0	FN FAL	item.wpn.fal.name	weapon/assault_rifle	RANK_MASTER
1139	y32wo	HK XM8	item.wpn.xm8.name	weapon/assault_rifle	RANK_MASTER
1140	wj75o	FN SCAR-H	item.wpn.scarh.name	weapon/assault_rifle	RANK_MASTER
1141	4qnyn	ПТРД-М	item.wpn.ptrd.name	weapon/heavy	RANK_MASTER
1142	knmdv	Винтовка Гаусса	item.wpn.gauss.name	weapon/sniper_rifle	RANK_LEGEND
1143	qj26k	FN SCAR SSR	item.wpn.scarssr.name	weapon/sniper_rifle	RANK_MASTER
1144	j5od6	FAMAS G2	item.wpn.famas.name	weapon/assault_rifle	RANK_MASTER
1145	rw2d5	McMillan CS5	item.wpn.mcmillan.name	weapon/sniper_rifle	RANK_MASTER
1146	0r211	Crye Precision SIX12	item.wpn.six12.name	weapon/shotgun_rifle	RANK_VETERAN
1147	okm20	HK PSG1	item.wpn.psg.name	weapon/sniper_rifle	RANK_VETERAN
1148	n4md3	HK XM8S	item.wpn.xm8s.name	weapon/assault_rifle	RANK_MASTER
1149	p63d2	HK417	item.wpn.hk417.name	weapon/assault_rifle	RANK_MASTER
1150	vj2zd	DSA-58	item.wpn.dsa58.name	weapon/assault_rifle	RANK_MASTER
1151	dmjdn	АК-308	item.wpn.ak308.name	weapon/assault_rifle	RANK_MASTER
1152	2ony6	IWI Tavor X95	item.wpn.x95.name	weapon/assault_rifle	RANK_MASTER
1153	7lnj7	SA-58 CTC	item.wpn.sa58.name	weapon/assault_rifle	RANK_MASTER
1154	969r0	«Цунами»	item.wpn.kedr_mod.name	weapon/submachine_gun	RANK_STALKER
1155	1r756	«Лягуха»	item.wpn.mp5_mod.name	weapon/submachine_gun	RANK_VETERAN
1156	rw27g	«Рапира»	item.wpn.aks74_mod.name	weapon/assault_rifle	RANK_VETERAN
1157	0r2zd	«Уравнитель»	item.wpn.l85_mod.name	weapon/assault_rifle	RANK_VETERAN
1158	m0m7j	ПП «Орех»	item.wpn.oreh.name	weapon/submachine_gun	RANK_VETERAN
1159	wj72d	АВТ-40	item.wpn.svt40_mod.name	weapon/sniper_rifle	RANK_VETERAN
1160	rw23l	«Волна»	item.wpn.svu_mod.name	weapon/sniper_rifle	RANK_MASTER
1161	1rj9g	ПМ вечного новичка	item.wpn.pm_mod.name	weapon/pistol	RANK_STALKER
1162	rwzmv	«Пчела»	item.wpn.p99_mod.name	weapon/pistol	RANK_STALKER
1163	g4vk6	«Мечта»	item.wpn.hp_mod.name	weapon/pistol	RANK_VETERAN
1164	ok9p6	«Большой Билл»	item.wpn.deagle_mod.name	weapon/pistol	RANK_MASTER
1165	g4v16	ВСК-94 Арсенала	item.wpn.vsk94_a.name	weapon/sniper_rifle	RANK_MASTER
1166	zzlwy	FAL Арсенала	item.wpn.fal_a.name	weapon/assault_rifle	RANK_MASTER
1167	5lgo1	XM8 Арсенала	item.wpn.xm8_a.name	weapon/assault_rifle	RANK_MASTER
1168	wj6l2	SCAR-H Арсенала	item.wpn.scarh_a.name	weapon/assault_rifle	RANK_MASTER
1169	4q17r	ПТРД-М Арсенала	item.wpn.ptrd_a.name	weapon/heavy	RANK_MASTER
1170	knv5y	HK417 Арсенала	item.wpn.hk417_a.name	weapon/assault_rifle	RANK_MASTER
1171	qjg3j	DSA-58 Арсенала	item.wpn.dsa58_a.name	weapon/assault_rifle	RANK_MASTER
1172	j5vz0	АК-308 Арсенала	item.wpn.ak308_a.name	weapon/assault_rifle	RANK_MASTER
1173	lyv9k	X95 Арсенала	item.wpn.x95_a.name	weapon/assault_rifle	RANK_MASTER
1174	rwz6v	«Волна» Арсенала	item.wpn.svu_mod_a.name	weapon/sniper_rifle	RANK_MASTER
1175	0rq99	«Руна» Арсенала	item.wpn.m16a3_rune_a.name	weapon/assault_rifle	RANK_MASTER
1176	m0v1y	«Инвертор» Арсенала	item.wpn.invertor_a.name	weapon/pistol	RANK_MASTER
1177	ok9z6	СВЧ Арсенала	item.wpn.svch_a.name	weapon/sniper_rifle	RANK_MASTER
1178	n42g1	AUG A3 Арсенала	item.wpn.aug3_a.name	weapon/assault_rifle	RANK_MASTER
1179	p615w	Derya MK-12 Арсенала	item.wpn.mk12_a.name	weapon/shotgun_rifle	RANK_MASTER
1180	vj40r	АК-12 Арсенала	item.wpn.ak12_a.name	weapon/assault_rifle	RANK_MASTER
1181	dmv6j	HK416 Арсенала	item.wpn.hk416_a.name	weapon/assault_rifle	RANK_MASTER
1182	2olgl	Cheytac M300 Арсенала	item.wpn.cheytac300_a.name	weapon/sniper_rifle	RANK_MASTER
1183	g4vj5	РГ-6	item.wpn.rg6.name	weapon/heavy	RANK_VETERAN
1184	zzlvm	Огнемет	item.wpn.flamethrower.name	weapon/heavy	RANK_VETERAN
1185	wj6m3	«Огниво»	item.wpn.flamepistol.name	weapon/heavy	RANK_VETERAN
1186	4q12o	«Хладорез»	item.wpn.coldcutter.name	weapon/heavy	RANK_MASTER
1187	knv1p	«Хладомет»	item.wpn.frostthrower.name	weapon/heavy	RANK_MASTER
1188	zzl6m	РПГ-7	item.wpn.rpg7.name	weapon/heavy	RANK_MASTER
1189	96w9q	Охотничий нож	item.21000.name	weapon/melee	RANK_STALKER
1190	1rj7r	Изделие 6Х4	item.21001.name	weapon/melee	DEFAULT
1191	g4vmn	Монтировка	item.21002.name	weapon/melee	RANK_STALKER
1192	zzl2k	ОЦ-04	item.melee.oc04.name	weapon/melee	RANK_VETERAN
1193	5lgno	Glock Feldmesser 78	item.21004.name	weapon/melee	RANK_STALKER
1194	y3j20	Gerber Downrange Tomahawk	item.melee.downrange.name	weapon/melee	RANK_MASTER
1195	wj67z	КО-1	item.21006.name	weapon/melee	RANK_NEWBIE
1196	4q1nj	Кукри	item.melee.kukri.name	weapon/melee	RANK_MASTER
1197	knvmj	Jagdkommando	item.21008.name	weapon/melee	RANK_MASTER
1198	qjg24	Саперная лопата	item.21009.name	weapon/melee	RANK_STALKER
1199	j5vol	Танто с кольцом	item.21010.name	weapon/melee	RANK_VETERAN
1200	lyv22	Охотничий мачете	item.21011.name	weapon/melee	RANK_VETERAN
1201	rwz2z	Русский штык	item.21012.name	weapon/melee	RANK_STALKER
1202	0rq2k	Ледоруб	item.melee.iceaxe.name	weapon/melee	RANK_VETERAN
1203	m0vmk	Топор	item.21014.name	weapon/melee	RANK_NEWBIE
1204	ok9m5	Молоток	item.21015.name	weapon/melee	RANK_NEWBIE
1205	n42m9	Мачете «ЭМЧес»	item.21016.name	weapon/melee	RANK_STALKER
1206	p613d	Штык-нож M9	item.21017.name	weapon/melee	RANK_VETERAN
1207	vj427	M48 Tomahawk	item.melee.m48.name	weapon/melee	RANK_VETERAN
1208	dmvjg	Телескопическая дубинка	item.21019.name	weapon/melee	RANK_STALKER
1209	2olnv	Бита с гвоздями	item.melee.bate.name	weapon/melee	RANK_VETERAN
1210	3g9n1	Алюминиевая бита	item.21021.name	weapon/melee	RANK_VETERAN
1211	7l5n9	Тесак	item.21022.name	weapon/melee	RANK_STALKER
1212	6wz6n	Мачете Survival SP8 Ontario	item.21023.name	weapon/melee	RANK_VETERAN
1213	96wwq	Кусок трубы	item.21024.name	weapon/melee	RANK_NEWBIE
1214	1rjjr	Старый серп	item.21025.name	weapon/melee	RANK_NEWBIE
1215	g4vvn	Саперная лопата	item.21009.name	weapon/melee	RANK_STALKER
1216	zzllk	Бритва	item.melee.britva.name	weapon/melee	RANK_VETERAN
1217	5lggo	Огненная бритва	item.melee.britva_fire.name	weapon/melee	RANK_VETERAN
1218	y3jj0	Кислотная бритва	item.melee.britva_acid.name	weapon/melee	RANK_VETERAN
1219	wj66z	Прижигатель	item.melee.burner.name	weapon/melee	RANK_MASTER
1220	4q11j	Нож из шипа	item.21031.name	weapon/melee	RANK_STALKER
1221	knvvj	Ледяной кукри	item.melee.kukri_f.name	weapon/melee	RANK_VETERAN
1222	qjgg4	Ледяной ледоруб	item.melee.iceaxe_f.name	weapon/melee	RANK_VETERAN
1223	j5vvl	Тесак военсталов	item.melee.vstesak.name	weapon/melee	RANK_VETERAN
1224	lyvv2	Твичер	item.21035.name	weapon/melee	RANK_VETERAN
1225	rwzzz	Нож 6Х9	item.21036.name	weapon/melee	RANK_NEWBIE
1226	0rqqk	УВСР	item.melee.uvsr.name	weapon/melee	RANK_VETERAN
1227	m0vvk	НР-43	item.21038.name	weapon/melee	RANK_STALKER
1228	ok995	Диверсионный нож	item.21039.name	weapon/melee	RANK_NEWBIE
1229	n4229	Керамбит из когтя	item.21040.name	weapon/melee	RANK_VETERAN
1230	p611d	Шипастая дубинка	item.21041.name	weapon/melee	RANK_STALKER
1231	dmvvg	«Друг болотника»	item.melee.bolotnik.name	weapon/melee	RANK_NEWBIE
1232	2ollv	Классический M9	item.21044.name	weapon/melee	RANK_STALKER
1233	3g991	Мясницкий нож	item.21045.name	weapon/melee	RANK_STALKER
1234	7l559	Нож с обратным хватом	item.21046.name	weapon/melee	RANK_STALKER
1235	6wzzn	Едкая пила	item.21047.name	weapon/melee	RANK_VETERAN
1236	96w5q	«Рвач»	item.21048.name	weapon/melee	RANK_STALKER
1237	1rjqr	Мясницкий крюк	item.21049.name	weapon/melee	RANK_STALKER
1238	rwzqz	Ритуальный топор	item.melee.raxe.name	weapon/melee	RANK_STALKER
1239	0rqkk	«Пламенный привет»	item.melee.fireknuckle.name	weapon/melee	RANK_STALKER
1240	m0v5k	Костяной нож	item.melee.boneknife.name	weapon/melee	RANK_VETERAN
1241	ok9w5	Мизерикорд	item.melee.misery.name	weapon/melee	RANK_MASTER
1242	n42y9	Керамбит Steel Tiger	item.melee.steeltiger.name	weapon/melee	RANK_MASTER
1243	p614d	Боевой нож «Катран-1»	item.melee.katran.name	weapon/melee	RANK_MASTER
1244	vj497	Казачья шашка	item.melee.shashka.name	weapon/melee	RANK_MASTER
1245	dmvog	Тактический нож Ka-Bar BKR3	item.melee.bkr3.name	weapon/melee	RANK_STALKER
1246	7l5g9	«Эндшпиль»	item.melee.endgame.name	weapon/melee	RANK_VETERAN
1247	6wz1n	«Флюорит»	item.melee.fluorite.name	weapon/melee	RANK_VETERAN
1248	1rjvr	«Гладиус»	item.melee.gladius.name	weapon/melee	RANK_VETERAN
1249	5lgvo	Синобигатана	item.melee.katana.name	weapon/melee	RANK_MASTER
1250	y3jp0	Кувалда	item.melee.sledgehammer.name	weapon/melee	RANK_LEGEND
1251	knvwj	Антитеррор	item.melee.antiterror.name	weapon/melee	RANK_MASTER
1252	qjgr4	Боевой топор Русов	item.melee.battleaxe.name	weapon/melee	RANK_VETERAN
1253	j5v6l	Тактическая катана	item.melee.katana_tactical.name	weapon/melee	RANK_MASTER
1254	lyv42	ZIVCAS Zeus-77	item.melee.baton.name	weapon/melee	RANK_VETERAN
1255	rwz0z	ZIVCAS Valor	item.melee.kortik.name	weapon/melee	RANK_MASTER
1256	ok9j5	Морозная бритва	item.melee.britva_frost.name	weapon/melee	RANK_MASTER
1257	n42q9	«Лепесток»	item.melee.petal.name	weapon/melee	RANK_MASTER
1258	zzpwy	Цевье MP5 с планками Пикатинни	item.att.forend_mp5ris.name	attachment/forend	RANK_NEWBIE
1259	5lvo1	Цевье RIS P90	item.att.forend_p90ris.name	attachment/forend	RANK_STALKER
1260	4qv7r	Цевье с направляющей RIS для Uzi	item.att.forend_uziris.name	attachment/forend	DEFAULT
1261	qjr3j	Цевье M1A с планкой Пикатинни	item.att.forend_m1ris1.name	attachment/forend	RANK_STALKER
1262	j56z0	Ложе M1A с планками Пикатинни	item.att.forend_m1ris2.name	attachment/forend	RANK_STALKER
1263	0rv99	Ложе Springfield M1A PACS	item.att.forend_m1pacs.name	attachment/forend	RANK_VETERAN
1264	ly4ok	Цевье для Сайга-12К	item.att.forend_saiga.name	attachment/forend	RANK_VETERAN
1265	rw09v	Тактическая накладка СКС	item.att.forend_skstop.name	attachment/forend	RANK_NEWBIE
1266	0rv69	Цевье Б-21М	item.att.forend_b21m.name	attachment/forend	RANK_NEWBIE
1267	vjp5r	Тактическое ложе для СКС	item.att.forend_sks.name	attachment/forend	DEFAULT
1268	3g72l	Набор планок для ППШ	item.att.forend_ppsh.name	attachment/forend	RANK_STALKER
1269	96v0y	Тактическая рукоятка KAC Vertical Foregrip	item.att.handgrip_magpul.name	attachment/other	RANK_STALKER
1270	1rvm2	Тактическая рукоятка Magpul AFG	item.att.handgrip_pclrs.name	attachment/other	RANK_STALKER
1271	g4gj5	Вертикальная рукоятка ANG4	item.att.handgrip_ang4.name	attachment/other	RANK_STALKER
1272	zzpvm	Тактическая рукоятка REG Fab Defence, хаки	item.att.handgrip_regfbh.name	attachment/other	RANK_MASTER
1273	5lv7q	Тактическая рукоятка REG Fab Defence, серый	item.att.handgrip_regfbb.name	attachment/other	RANK_MASTER
1274	y3po3	Рукоятка для ОЦ-14 «Гроза»	item.att.handgrip_groza.name	attachment/barrel	RANK_VETERAN
1275	knw1p	Тактическая рукоятка Fortis SHIFT Vertical, оранжевая	item.att.handgrip_fortiso.name	attachment/other	RANK_VETERAN
1276	qjr43	Тактическая рукоятка Fortis SHIFT Vertical, черная	item.att.handgrip_fortisb.name	attachment/other	RANK_VETERAN
1277	j569g	Рукоять переноса огня FMA DARK EARTH	item.att.handgrip_fmade.name	attachment/other	RANK_NEWBIE
1278	ly4go	Тактическая рукоятка FMA TD Grip	item.att.handgrip_fmatd.name	attachment/other	RANK_NEWBIE
1279	rw0ky	Вертикальная рукоятка Tapco	item.att.handgrip_tapco.name	attachment/other	RANK_STALKER
1280	0rvyy	Тактическая рукоятка Viking Tactics UVG	item.att.handgrip_viking.name	attachment/other	RANK_MASTER
1281	m0kz2	FX PTKB FAB Defense	item.att.handgrip_fxptkb.name	attachment/other	RANK_STALKER
1282	okjym	Magpul RVG	item.att.handgrip_rvg.name	attachment/other	RANK_VETERAN
1283	n4q52	РК-5	item.att.handgrip_rk5.name	attachment/other	RANK_NEWBIE
1284	p6lw4	РК-0	item.att.handgrip_rk0.name	attachment/other	RANK_STALKER
1285	vjpmp	РК-1	item.att.handgrip_rk1.name	attachment/other	RANK_VETERAN
1286	dm0z2	РК-2	item.att.handgrip_rk2.name	attachment/other	RANK_MASTER
1287	3g7k5	«Дистония»	item.att.handgrip_murmur.name	attachment/other	RANK_MASTER
1288	7l62j	Тактическая рукоятка «Перо»	item.att.handgrip_arsenal_feather.name	attachment/other	RANK_MASTER
1289	6wv20	Тактическая рукоятка «Утяжелитель»	item.att.handgrip_arsenal_heavy.name	attachment/other	RANK_MASTER
1290	96v2y	Тактическая рукоятка «Блиц»	item.att.handgrip_arsenal_blitz.name	attachment/other	RANK_MASTER
1291	96v5q	Прицел оптический SUSAT	item.att.scope_susat.name	attachment/collimator_sights	RANK_NEWBIE
1292	1rvqr	Прицел оптический Leupold	item.att.scope_hamr.name	attachment/collimator_sights	RANK_NEWBIE
1293	g4gon	Прицел оптический Elcan	item.att.scope_elcan4.name	attachment/collimator_sights	RANK_STALKER
1294	zzp5k	Прицел оптический Trijicon ACOG	item.att.scope_acog6.name	attachment/collimator_sights	RANK_STALKER
1295	5lv9o	Прицел оптический Sig Sauer	item.att.scope_bravo.name	attachment/collimator_sights	RANK_VETERAN
1296	y3pz0	Прицел оптический Trijicon AccuPoint	item.att.scope_tr20.name	attachment/collimator_sights	RANK_VETERAN
1297	wjp1z	Прицел оптический Trijicon ACOG	item.att.scope_acog4.name	attachment/collimator_sights	RANK_NEWBIE
1298	4qv6j	Прицел оптический Elcan M145	item.att.scope_m145.name	attachment/collimator_sights	RANK_STALKER
1299	qjrk4	Прицел оптический Elcan	item.att.scope_elcan6.name	attachment/collimator_sights	RANK_STALKER
1300	j561l	Прицел оптический Барс	item.att.scope_bars.name	attachment/collimator_sights	RANK_STALKER
1301	ly4z2	Прицел оптический Acecare	item.att.scope_acecare.name	attachment/collimator_sights	RANK_VETERAN
1302	0rvkk	Прицел оптический Trijicon ACOG 2x40	item.att.scope_acog2.name	attachment/collimator_sights	RANK_MASTER
1303	g4g2n	Прицел широкоугольный «Ракурс»	item.att.scope_rakurs.name	attachment/collimator_sights	RANK_NEWBIE
1304	zzp9k	Прицел оптический ПСО	item.att.scope_pso1.name	attachment/collimator_sights	RANK_NEWBIE
1305	5lvpo	Прицел оптический 1П77	item.att.scope_1p77.name	attachment/collimator_sights	RANK_NEWBIE
1306	y3pm0	Прицел оптический ПОСП	item.att.scope_psop.name	attachment/collimator_sights	RANK_STALKER
1307	wjprz	Прицел оптический ПУ на боковой кронштейн	item.att.scope_pu.name	attachment/collimator_sights	DEFAULT
1308	4qvpj	Прицел оптический ПСО	item.att.scope_pso3.name	attachment/collimator_sights	RANK_STALKER
1309	knw9j	Прицел оптический ПУ для СВТ	item.att.scope_svt.name	attachment/collimator_sights	DEFAULT
1310	qjrw4	Прицел оптический «Тюльпан»	item.att.scope_1p29.name	attachment/collimator_sights	RANK_NEWBIE
1311	j562l	Прицел оптический Пилад 3.5х20	item.att.scope_pilad.name	attachment/collimator_sights	RANK_STALKER
1312	96vjz	Прицел коллиматорный Micro	item.att.sight_microt1.name	attachment/collimator_sights	DEFAULT
1313	1rvg1	Прицел коллиматорный EoTech	item.att.sight_eoth.name	attachment/collimator_sights	RANK_NEWBIE
1314	g4gdp	Прицел коллиматорный EoTech	item.att.sight_eotb.name	attachment/collimator_sights	RANK_NEWBIE
1315	zzp4n	Прицел коллиматорный Trijicon	item.att.sight_rmr.name	attachment/collimator_sights	RANK_NEWBIE
1316	5lvw0	Прицел коллиматорный LaRue	item.att.sight_irondot.name	attachment/collimator_sights	RANK_NEWBIE
1317	y3pwo	Прицел коллиматорный ОКП-7	item.att.sight_okp.name	attachment/collimator_sights	RANK_VETERAN
1318	wjp5o	Прицел коллиматорный BSA Reflex	item.att.sight_bsa.name	attachment/collimator_sights	RANK_NEWBIE
1319	4qvyn	Прицел коллиматорный «Валдай»	item.att.sight_valdai.name	attachment/collimator_sights	RANK_NEWBIE
1320	knwdv	Прицел коллиматорный Barska	item.att.sight_barska_open.name	attachment/collimator_sights	RANK_VETERAN
1321	j56d6	Прицел коллиматорный Barska	item.att.sight_barska_closed.name	attachment/collimator_sights	RANK_VETERAN
1322	ly4d1	Прицел коллиматорный «Bering OPTICS»	item.att.sight_bering.name	attachment/collimator_sights	RANK_STALKER
1323	rw0d5	Прицел коллиматорный «Bering OPTICS»	item.att.sight_bering2.name	attachment/collimator_sights	RANK_STALKER
1324	0rv11	Прицел коллиматорный Vortex	item.att.sight_uh1.name	attachment/collimator_sights	RANK_STALKER
1325	m0kd7	Прицел коллиматорный Vortex	item.att.sight_vortex2.name	attachment/collimator_sights	RANK_STALKER
1326	okj20	Прицел коллиматорный Trijicon	item.att.sight_srs.name	attachment/collimator_sights	RANK_NEWBIE
1327	n4qd3	Прицел коллиматорный Trijicon	item.att.sight_1x42.name	attachment/collimator_sights	RANK_STALKER
1328	p6ld2	Прицел коллиматорный Sig Sauer	item.att.sight_romeo3.name	attachment/collimator_sights	RANK_STALKER
1329	vjpzd	Прицел коллиматорный ПК-01(Т)	item.att.sight_pk01t.name	attachment/collimator_sights	RANK_VETERAN
1330	dm0dn	Прицел коллиматорный ПК-01(Т/З)	item.att.sight_pk01tz.name	attachment/collimator_sights	RANK_VETERAN
1331	2o2y6	Прицел коллиматорный РУСАК	item.att.sight_rusak.name	attachment/collimator_sights	RANK_NEWBIE
1332	3g7wg	Прицел коллиматорный DM	item.att.sight_dm51.name	attachment/collimator_sights	RANK_VETERAN
1333	7l6j7	Прицел коллиматорный «Кобра»	item.att.sight_cobra_pik.name	attachment/collimator_sights	RANK_NEWBIE
1334	6wvqy	Прицел коллиматорный Панорама	item.att.sight_panorama.name	attachment/collimator_sights	RANK_VETERAN
1335	1rv51	Прицел коллиматорный DOTSAT	item.att.sight_dotsat.name	attachment/collimator_sights	RANK_MASTER
1336	g4g6p	Прицел коллиматорный Walther	item.att.sight_walther103.name	attachment/collimator_sights	RANK_VETERAN
1337	zzpdn	Прицел «Композит 2.8»	item.att.sight_murmur28.name	attachment/collimator_sights	RANK_MASTER
1338	5lvk0	Прицел коллиматорный «Перспектива»	item.att.sight_murmur18.name	attachment/collimator_sights	RANK_MASTER
1339	y3pdo	Прицел коллиматорный «Трапеция»	item.att.sight_murmur24.name	attachment/collimator_sights	RANK_MASTER
1340	g4gyp	Прицел коллиматорный «Обзор»	item.att.sight_obzor.name	attachment/collimator_sights	DEFAULT
1341	zzpyn	Прицел коллиматорный «Кобра»	item.att.sight_cobra.name	attachment/collimator_sights	RANK_NEWBIE
1342	5lvr0	Прицел коллиматорный «ПК-АС»	item.att.sight_pkas.name	attachment/collimator_sights	RANK_STALKER
1343	zzpm2	Лазерный целеуказатель «Клещ-2ПС»	item.att.lcu_compact.name	attachment/other	RANK_STALKER
1344	5lvmg	Тактический блок AN/PEQ 15, хаки	item.att.lcu_anpeqh.name	attachment/other	RANK_MASTER
1345	y3prz	Тактический блок AN/PEQ 15, черный	item.att.lcu_anpeqb.name	attachment/other	RANK_MASTER
1346	j56y7	Тактический блок AN/PEQ 15, черный (зеленый лазер)	item.att.lcu_anpeqbg.name	attachment/other	RANK_MASTER
1347	ly4qj	HQ ISSUE Mini Laser Sight (зеленый лазер)	item.att.lcu_hqi.name	attachment/other	RANK_NEWBIE
1348	rw03g	HQ ISSUE Low-Profile Laser Sight (красный лазер)	item.att.lcu_lowp.name	attachment/other	RANK_STALKER
1349	0rv5d	Тактический блок Зенит «Перст-3»	item.att.lcu_perst3.name	attachment/other	RANK_VETERAN
1350	96p6w	Пламегаситель Noveske KX3	item.att.barrel_noveske.name	attachment/barrel	RANK_NEWBIE
1351	1r3rq	Diamondhead Compensator	item.att.barrel_diamondhead.name	attachment/barrel	RANK_STALKER
1352	g424g	Resistance Armament Compensator	item.att.barrel_resistance.name	attachment/barrel	RANK_NEWBIE
1353	zz9z9	Hera Arms CC Compensator	item.att.barrel_heracc.name	attachment/barrel	RANK_STALKER
1354	5lpl4	Пламегаситель LoneWolf	item.att.barrel_lonewolf.name	attachment/barrel	RANK_STALKER
1355	y3m3w	3 Port Mini Compensator	item.att.barrel_3port.name	attachment/barrel	RANK_STALKER
1356	wjrjd	VG6 EPSILON 556 Muzzle Brake	item.att.barrel_vg6556.name	attachment/barrel	RANK_VETERAN
1357	4qpql	VG6 EPSILON 762 Muzzle Brake	item.att.barrel_vg6762.name	attachment/barrel	RANK_VETERAN
1358	qjwj9	Пламегаситель Lantac Dragon 7.62	item.att.barrel_lantac_dragon.name	attachment/barrel	RANK_MASTER
1359	j5254	Пламегаситель Lantac BMD	item.att.barrel_lantac_bmd.name	attachment/barrel	RANK_MASTER
1360	ly1yq	AlienTech 5.56	item.att.barrel_alientech556.name	attachment/barrel	RANK_STALKER
1361	rw4jl	Bulletec ST-6012	item.att.barrel_bulletecst6012.name	attachment/barrel	RANK_VETERAN
1362	0rp0r	Precision Armament M11 Severe Duty 7.62x51	item.att.barrel_pam11762.name	attachment/barrel	RANK_STALKER
1363	m0grr	SureFire Pro Comp 7.62x51	item.att.barrel_surefirepro762.name	attachment/barrel	RANK_STALKER
1364	ok5l4	Odin Works ATLAS 7.62x51	item.att.barrel_odinatlas762.name	attachment/barrel	RANK_VETERAN
1365	n4zkw	Vendetta Precision VP-09 Interceptor	item.att.barrel_vp09.name	attachment/barrel	RANK_VETERAN
1366	p6yj5	HK BLITZ 5.56	item.att.barrel_hkblitz556.name	attachment/barrel	RANK_STALKER
1367	vjlng	CMMG SV Brake 7.62x51	item.att.barrel_cmmgsvbrake762.name	attachment/barrel	RANK_STALKER
1368	dm2r9	Keeno Arms SHREWD 7.62x51	item.att.barrel_kashrewd762.name	attachment/barrel	RANK_STALKER
1369	2o71m	VR-09	item.att.barrel_vr09.name	attachment/barrel	RANK_NEWBIE
1370	3gp4k	Hi-Point Razor	item.att.barrel_hipointrazor.name	attachment/barrel	RANK_STALKER
1371	7lp7r	GE-OCTO Gunethics	item.att.barrel_gunethics.name	attachment/barrel	RANK_VETERAN
1372	6wpo6	Удлиненный ствол D-Eagle	item.att.barrel_longdeagle.name	attachment/barrel	RANK_VETERAN
1373	1r39q	Пламегаситель AKademia Тьма	item.att.barrel_akademia.name	attachment/barrel	RANK_NEWBIE
1374	g42ng	ДТК «Косой»	item.att.barrel_kosoi.name	attachment/barrel	RANK_STALKER
1375	zz939	ДТК «Вихрь»	item.att.barrel_vihr.name	attachment/barrel	RANK_STALKER
1376	5lp54	ДТК-1	item.att.barrel_dtk1.name	attachment/barrel	RANK_STALKER
1377	y3m4w	ДТК Цитадель 5.45	item.att.barrel_citadel.name	attachment/barrel	RANK_VETERAN
1378	wjr3d	Удлиненный ствол 9 мм	item.att.barrel_extension9mm.name	attachment/barrel	RANK_VETERAN
1379	4qpkl	ДТК АШ-12	item.att.barrel_ash12.name	attachment/barrel	RANK_MASTER
1380	kn9r3	ДТК-2	item.att.barrel_dtk2.name	attachment/barrel	RANK_NEWBIE
1381	qjw09	PWS CQB 74	item.att.barrel_pwscqb74.name	attachment/barrel	RANK_STALKER
1382	j5204	Jmac Customs RDC 4C 5.45	item.att.barrel_jmac545.name	attachment/barrel	RANK_VETERAN
1383	ly10q	АКМЛ	item.att.barrel_akml.name	attachment/barrel	RANK_STALKER
1384	rw4ml	Jmac Customs RDC 4C 7.62	item.att.barrel_jmac762.name	attachment/barrel	RANK_VETERAN
1385	0rp7r	Fortis RED Brake	item.att.barrel_fortisrb.name	attachment/barrel	RANK_MASTER
1386	m0g4r	SRVV MBR Jet	item.att.barrel_sprvmbrjet.name	attachment/barrel	RANK_STALKER
1387	ok544	ДТК QD556 Sport Adjustable Saimaa Still	item.att.barrel_qd556sass.name	attachment/barrel	RANK_MASTER
1388	n4zjw	Spikes Tactical Dynacomp	item.att.barrel_spikesdynacomp.name	attachment/barrel	RANK_STALKER
1389	p6yv5	SPVV 7.62	item.att.barrel_sprv762.name	attachment/barrel	RANK_STALKER
1390	vjlog	Venom Tactical Antidote	item.att.barrel_venomantidote.name	attachment/barrel	RANK_VETERAN
1391	dm259	ДТК Кочевник 9	item.att.barrel_nomad9.name	attachment/barrel	RANK_MASTER
1392	2o7rm	MICRO BADGER	item.att.barrel_microbadger.name	attachment/barrel	RANK_NEWBIE
1393	3gpok	Custom Guns Doncaster	item.att.barrel_cgdoncaster.name	attachment/barrel	RANK_STALKER
1394	7lpwr	Titan-9 Long	item.att.barrel_titan9long.name	attachment/barrel	RANK_MASTER
1395	6wpy6	ДТК «Окоём»	item.att.barrel_arsenal_boar.name	attachment/barrel	RANK_MASTER
1396	96p3w	Пламегаситель «Крен»	item.att.barrel_arsenal_roll.name	attachment/barrel	RANK_MASTER
1397	g42kg	Глушитель SUPRA K-8 С.К.О.С.	item.att.silencer_js.name	attachment/barrel	RANK_STALKER
1398	zz9k9	Глушитель Osprey	item.att.silencer_osprey.name	attachment/barrel	RANK_VETERAN
1399	5lpy4	Глушитель SCAR-SD	item.att.silencer_scarsd.name	attachment/barrel	RANK_STALKER
1400	y3mgw	Глушитель FA556 Mini	item.att.silencer_fa556.name	attachment/barrel	RANK_VETERAN
1401	wjr9d	Глушитель Salvo 12	item.att.silencer_salvo12.name	attachment/barrel	RANK_VETERAN
1402	4qpol	Глушитель KAC Style QD	item.att.silencer_kacqd.name	attachment/barrel	RANK_VETERAN
1403	j52n4	SIG Sauer SRD762Ti	item.att.silencer_srd762ti.name	attachment/barrel	RANK_VETERAN
1404	ly1kq	Глушитель SureFire SOCOM556-RC2	item.att.silencer_socom556.name	attachment/barrel	RANK_STALKER
1405	rw4vl	Hybrid 46	item.att.silencer_hybrid46.name	attachment/barrel	RANK_MASTER
1406	m0gqr	«Антитеза»	item.att.silencer_murmur.name	attachment/barrel	RANK_MASTER
1407	ok5p4	Глушитель «Торопыжка»	item.att.silencer_arsenal_indifferent.name	attachment/barrel	RANK_MASTER
1408	5lpo4	ПБС-4	item.att.silencer_pbs4.name	attachment/barrel	RANK_STALKER
1409	y3mnw	Глушитель АТГ	item.att.silencer_atg.name	attachment/barrel	RANK_VETERAN
1410	wjrld	Глушитель для ОЦ-14 «Гроза»	item.att.silencer_groza.name	attachment/barrel	RANK_VETERAN
1411	4qp7l	Имкас ПСУЗВ–11ТМ.12	item.att.silencer_imkas.name	attachment/barrel	RANK_VETERAN
1412	qjwq9	Глушитель АШ-12/МЦ-558	item.att.silencer_ash12_mc558.name	attachment/barrel	RANK_MASTER
1413	j52q4	Глушитель МЦ-558	item.att.silencer_mc558.name	attachment/barrel	RANK_MASTER
1414	0rp9r	ПБС-1	item.att.silencer_pbs1.name	attachment/barrel	RANK_STALKER
1415	96p2y	Магазин 5.56 NATO STANAG	item.att.mag_stanag20.name	attachment/mag	RANK_NEWBIE
1416	1r362	Магазин 5.56 NATO STANAG	item.att.mag_stanag30.name	attachment/mag	RANK_STALKER
1417	g42w5	Магазин 5.56 NATO PMAG, хаки	item.att.mag_pmag30h.name	attachment/mag	RANK_STALKER
1418	zz96m	Магазин 5.56 NATO PMAG, черный	item.att.mag_pmag30b.name	attachment/mag	RANK_STALKER
1419	5lpdq	Магазин 5.56 NATO STANAG	item.att.mag_stanag40.name	attachment/mag	RANK_VETERAN
1420	y3m73	Магазин 5.56 NATO STANAG	item.att.mag_stanag60.name	attachment/mag	RANK_VETERAN
1421	wjro3	Барабанный магазин 5.56 NATO, хаки	item.att.mag_cmag100h.name	attachment/mag	RANK_MASTER
1422	4qp0o	Барабанный магазин 5.56 NATO черный	item.att.mag_cmag100b.name	attachment/mag	RANK_MASTER
1423	kn9lp	Барабанный магазин X-5	item.att.mag_x550.name	attachment/mag	RANK_STALKER
1424	qjwv3	Барабанный магазин AA-12	item.att.mag_aa1220.name	attachment/mag	RANK_MASTER
1425	j52lg	Магазин 7.62 NATO PMAG, хаки	item.att.mag_pmag76230h.name	attachment/mag	RANK_MASTER
1426	ly1lo	Магазин 7.62 NATO PMAG, черный	item.att.mag_pmag76230b.name	attachment/mag	RANK_MASTER
1427	rw4ry	Барабанный магазин 5.56 NATO EMAG	item.att.mag_emag55660.name	attachment/mag	RANK_MASTER
1428	0rp3y	Магазин 5.56 Pufgun, черный	item.att.mag_pufgun556b.name	attachment/mag	RANK_VETERAN
1429	m0g22	Увеличенный магазин Browning	item.att.mag_browning.name	attachment/mag	RANK_STALKER
1430	ok5vm	Увеличенный магазин Colt	item.att.mag_colt.name	attachment/mag	RANK_STALKER
1431	n4zp2	Увеличенный магазин Beretta	item.att.mag_beretta.name	attachment/mag	RANK_STALKER
1432	p6yr4	Барабанный магазин G3/M1A	item.att.mag_g350.name	attachment/mag	RANK_MASTER
1433	dm2q2	Магазин EMAG	item.att.mag_sig40.name	attachment/mag	RANK_VETERAN
1434	3gpr5	Увеличенный магазин SIG Sauer P320	item.att.mag_p320.name	attachment/mag	RANK_MASTER
1435	7lprj	Барабанный магазин Scorpion	item.att.mag_scorpion.name	attachment/mag	RANK_MASTER
1436	96pmy	Магазин PMAG GEN2 M2 MOE	item.att.mag_pmag556gen2.name	attachment/mag	RANK_VETERAN
1437	1r3d2	Эргономичный магазин 7.62 NATO	item.att.mag_ergo762nato.name	attachment/mag	RANK_MASTER
1438	g4205	Эргономичный магазин 5.56	item.att.mag_ergo556.name	attachment/mag	RANK_MASTER
1439	5lpgq	Магазин 5.45 бакелитовый	item.att.mag_rumag54545b.name	attachment/mag	RANK_STALKER
1440	y3mj3	Магазин 5.45 пластиковый	item.att.mag_rumag54545p.name	attachment/mag	RANK_VETERAN
1441	wjr63	Магазин 5.45	item.att.mag_rumag54560.name	attachment/mag	RANK_VETERAN
1442	4qp1o	Барабанный магазин 5.45	item.att.mag_rumag54575.name	attachment/mag	RANK_MASTER
1443	kn9vp	Барабанный магазин для ПМ	item.att.mag_pmdrum.name	attachment/mag	RANK_STALKER
1444	qjwg3	Магазин эргономичный для ВСС/Вал	item.att.mag_vss20.name	attachment/mag	RANK_VETERAN
1445	j52vg	Магазин ПП-91	item.att.mag_kedr40.name	attachment/mag	DEFAULT
1446	ly1vo	Увеличенный магазин «Кобра»	item.att.mag_svu15.name	attachment/mag	RANK_VETERAN
1447	rw4zy	Магазин ПП-2000	item.att.mag_pp200040.name	attachment/mag	RANK_NEWBIE
1448	0rpqy	Магазин 7.62 пластиковый	item.att.mag_rumag762p.name	attachment/mag	RANK_VETERAN
1449	m0gv2	Магазин 7.62 бакелитовый	item.att.mag_rumag762b.name	attachment/mag	RANK_STALKER
1450	ok59m	Магазин 5.45 PMAG, черный	item.att.mag_pmag545b.name	attachment/mag	RANK_STALKER
1451	n4z22	Увеличенный магазин ПМ/ПБ	item.att.mag_pm.name	attachment/mag	DEFAULT
1452	p6y14	Увеличенный магазин Форт-12	item.att.mag_fort12.name	attachment/mag	RANK_NEWBIE
1453	vjl4p	Удлинитель магазина МР-133/МР-153	item.att.mag_mr133.name	attachment/mag	RANK_NEWBIE
1454	dm2v2	Увеличенный магазин для ВСС/Вал	item.att.mag_val30.name	attachment/mag	RANK_MASTER
1455	2o7l5	Увеличенный магазин ОЦ-14	item.att.mag_groza30.name	attachment/mag	RANK_VETERAN
1456	3gp95	Увеличенный магазин для МЦ-558	item.att.mag_mc55810.name	attachment/mag	RANK_MASTER
1457	7lp5j	Увеличенный магазин PSG1	item.att.mag_psg1.name	attachment/mag	RANK_VETERAN
1458	96pwy	Увеличенный магазин АК-308	item.att.mag_ak30830.name	attachment/mag	RANK_MASTER
1459	1r3j2	Барабанный магазин 7.62x39	item.att.mag_rumag76275.name	attachment/mag	RANK_MASTER
1516	wjgm2	Дождевик	item.arm.raincoat.name	armor/scientist	DEFAULT
1460	y3mz3	Барабанный магазин ППШ	item.att.mag_ppsh.name	attachment/mag	RANK_STALKER
1461	4qp6o	Увеличенный магазин АШ-12	item.att.mag_ash12.name	attachment/mag	RANK_MASTER
1462	qjwk3	Магазин 5.45 «Вафля»	item.att.mag_545waffle.name	attachment/mag	RANK_VETERAN
1463	j521g	Магазин MAG SG545	item.att.mag_sg545.name	attachment/mag	RANK_VETERAN
1464	ly1zo	Магазин АКМ десантный	item.att.mag_trooper762.name	attachment/mag	RANK_VETERAN
1465	rw4qy	Магазин Magpul PMAG 7.62x39	item.att.mag_pmag76239.name	attachment/mag	RANK_VETERAN
1466	0rpky	Эргономичный магазин 7.62	item.att.mag_ergo76254.name	attachment/mag	RANK_MASTER
1467	m0g52	Эргономичный магазин 7.62x39	item.att.mag_ergo76239.name	attachment/mag	RANK_MASTER
1468	ok5wm	Эргономичный магазин 5.45	item.att.mag_ergo545.name	attachment/mag	RANK_MASTER
1469	n4zy2	Эргономичный магазин 12.7	item.att.mag_ergo127.name	attachment/mag	RANK_MASTER
1470	p6y44	Эргономичный магазин 9x39	item.att.mag_ergo939.name	attachment/mag	RANK_MASTER
1471	vjl9p	Барабанный магазин 6П62	item.att.mag_drum6p62.name	attachment/mag	RANK_MASTER
1472	6wp10	Самодельный магазин 7.62x39	item.att.mag_samodel76245.name	attachment/mag	RANK_VETERAN
1473	96pvq	Защитная планка, олива	item.att.other_deflongg.name	attachment/other	DEFAULT
1474	1r3vr	Защитная планка, хаки	item.att.other_deflongh.name	attachment/other	DEFAULT
1475	g42gn	Защитная планка, черная	item.att.other_deflongb.name	attachment/other	DEFAULT
1476	zz9pk	Компактная защитная планка, олива	item.att.other_defg.name	attachment/other	DEFAULT
1477	5lpvo	Компактная защитная планка, хаки	item.att.other_defh.name	attachment/other	DEFAULT
1478	y3mp0	Компактная защитная планка,черная	item.att.other_defb.name	attachment/other	DEFAULT
1479	96prz	Надствольное крепление БМ	item.att.forend_bm.name	attachment/forend	DEFAULT
1480	1r351	Кронштейн-планка RIS	item.att.mount_mp5ris.name	attachment/forend	RANK_NEWBIE
1481	g426p	Планка с базой Пикатинни	item.att.mount_tozris.name	attachment/forend	RANK_NEWBIE
1482	zz9dn	Боковой кронштейн с планкой Пикатинни	item.att.mount_lastris.name	attachment/forend	RANK_STALKER
1483	y3mdo	Направляющая RIS для дробовиков	item.att.mount_shotgunris.name	attachment/forend	RANK_NEWBIE
1484	qjw7k	Кронштейн СКС - ласточкин хвост	item.att.mount_skslast.name	attachment/forend	RANK_NEWBIE
1485	m0g77	Кронштейн Кочетова «Патриот» с планкой Пикатинни	item.att.mount_mosinris.name	attachment/forend	DEFAULT
1486	ok570	Планка RIS на ПП-91 «Кедр»	item.att.forend_kedrris.name	attachment/forend	DEFAULT
1487	vjl7d	Крепление прицела для M16A2	item.att.mount_m16ris.name	attachment/forend	RANK_NEWBIE
1488	dm27n	Повышающая RIS-планка	item.att.mount_riselevator.name	attachment/forend	RANK_STALKER
1489	2o7q6	Планка Пикатинни для СВТ	item.att.mount_svt.name	attachment/forend	DEFAULT
1490	3gp6g	Планка Пикатинни для Mauser 98k	item.att.mount_mauser.name	attachment/forend	RANK_NEWBIE
1491	96ldw	Рукоять РК-3	item.att.handle_rk3.name	attachment/pistol_handle	RANK_STALKER
1492	1rz9q	Рукоять Fab defence AG-47, черный	item.att.handle_ag47b.name	attachment/pistol_handle	RANK_STALKER
1493	g4qng	Рукоять Fab defence AG-47, зеленый	item.att.handle_ag47g.name	attachment/pistol_handle	RANK_STALKER
1494	zzr39	Рукоять Fab defence AG-47, хаки	item.att.handle_ag47h.name	attachment/pistol_handle	RANK_STALKER
1495	g4q1g	Рукоять Fab defence AGR-43, черный	item.att.handle_agr43b.name	attachment/pistol_handle	RANK_STALKER
1496	zzrw9	Рукоять Fab defence AGR-43, зеленый	item.att.handle_agr43g.name	attachment/pistol_handle	RANK_STALKER
1497	5l4o4	Рукоять Fab defence AGR-43, хаки	item.att.handle_agr43h.name	attachment/pistol_handle	RANK_STALKER
1498	1rgzr	Бронзовый жетон сталкера	item.24001.name	attachment/accessory	DEFAULT
1499	g4dqn	Серебряный жетон сталкера	item.24002.name	attachment/accessory	DEFAULT
1500	zz4rk	Золотой жетон сталкера	item.24003.name	attachment/accessory	DEFAULT
1501	lydm2	Бронзовый жетон бандита	item.24011.name	attachment/accessory	DEFAULT
1502	rwd5z	Серебряный жетон бандита	item.24012.name	attachment/accessory	DEFAULT
1503	0r1gk	Золотой жетон бандита	item.24013.name	attachment/accessory	DEFAULT
1504	g461g	Брелок «Неизвестное Вещество»	item.charm.veshestvo.name	attachment/accessory	DEFAULT
1505	zzdw9	Брелок «Экспериментальная Пси-сыворотка»	item.charm.psy_sivor.name	attachment/accessory	DEFAULT
1506	n47ow	Брелок «Механическая лапка»	item.charm.incident_noga.name	attachment/accessory	DEFAULT
1507	p67o5	Брелок «Ключ»	item.charm.incident_wrench.name	attachment/accessory	DEFAULT
1508	vj75g	Брелок «Всегда готов»	item.charm.incident_vsegda_gotov.name	attachment/accessory	DEFAULT
1509	2oywm	Брелок «Дух»	item.24368.name	attachment/accessory	DEFAULT
1510	96n2l	Куртка	item.arm.kyrtka.name	armor/clothes	DEFAULT
1511	1rk6g	Бандитский кожак	item.arm.kyrtka_bandit.name	armor/clothes	DEFAULT
1512	g4yw6	Бандитский кожак	item.arm.kyrtka_koj_bandit.name	armor/clothes	DEFAULT
1513	zzy6y	Бандитский «Крот»	item.arm.krot_bandit.name	armor/clothes	DEFAULT
1514	5lr71	Сталкерская кожанка	item.arm.kyrtka_koj.name	armor/clothes	DEFAULT
1515	y35ok	Костюм «Крот»	item.arm.krot.name	armor/clothes	DEFAULT
1517	4ql2r	Куртка с бронежилетом	item.arm.bronj.name	armor/combat	DEFAULT
1518	knqly	Броня репортера	item.arm.bronj_press.name	armor/combat	RANK_VETERAN
1519	rwnrv	Костюм «Горка-3»	item.arm.gorka.name	armor/combined	DEFAULT
1520	m062y	Куртка с бронежилетом	item.arm.bronj_bandit.name	armor/combat	DEFAULT
1521	dmgqj	Охотничий плащ	item.arm.vestcoat.name	armor/combat	DEFAULT
1522	2oqdl	Защитный костюм «Ворса»	item.arm.vorsa.name	armor/combat	RANK_STALKER
1523	3g6rl	Бронекостюм «Гоплит»	item.arm.goplit.name	armor/combat	RANK_VETERAN
1524	7lmr6	Костюм «Траппер»	item.arm.trapper.name	armor/combat	RANK_NEWBIE
1525	wjgo2	ИП-4м	item.arm.ip4m.name	armor/scientist	DEFAULT
1526	4ql0r	Плащ	item.arm.longcoat.name	armor/combat	DEFAULT
1527	knqmy	Бандитский плащ	item.arm.longcoat_bandit.name	armor/combat	DEFAULT
1528	qjo2j	Комбинезон «Аврора»	item.arm.zarya.name	armor/combined	DEFAULT
1529	j5ko0	Комбинезон «Аврора» с противогазом	item.arm.zarya_gas.name	armor/combined	RANK_NEWBIE
1530	lyj2k	Комбинезон «Аврора-Б»	item.arm.zarya_balon.name	armor/scientist	RANK_NEWBIE
1531	rwn2v	Комбинезон «Грибник»	item.arm.turist.name	armor/combined	RANK_NEWBIE
1532	0r429	Бандитский костюм	item.arm.bover.name	armor/combined	DEFAULT
1533	m06my	Бандитский костюм с противогазом	item.arm.bover_gas.name	armor/combined	RANK_NEWBIE
1534	ok0m6	Бандитский костюм с баллонами	item.arm.bover_balon.name	armor/scientist	RANK_NEWBIE
1535	n4rm1	Костюм «Клептоман»	item.arm.klepto.name	armor/combined	RANK_NEWBIE
1536	p6m3w	Бронекостюм «Комбат-5М»	item.arm.berill.name	armor/combat	RANK_NEWBIE
1537	vj12r	Бронекостюм «Червь»	item.arm.worm.name	armor/combat	RANK_NEWBIE
1538	dmgjj	Лечебный «Комбат»	item.arm.berill_lech.name	armor/combat	RANK_STALKER
1539	2oqnl	Костюм АО-1 «Бродяга»	item.arm.ao1.name	armor/combined	RANK_NEWBIE
1540	3g6nl	Маскировочный костюм «Смородина»	item.arm.smorodina.name	armor/combat	DEFAULT
1541	7lmn6	Защитный костюм «Псарь»	item.arm.dogger.name	armor/combat	RANK_NEWBIE
1542	6w06p	Костюм «Скаут»	item.arm.scout.name	armor/combat	RANK_NEWBIE
1543	96n9l	Бронекостюм «Страйкер»	item.arm.striker.name	armor/combat	RANK_STALKER
1544	1rk7g	ЗК-1 «Отмычка»	item.arm.picklock.name	armor/combined	DEFAULT
1545	g4ym6	Комбинезон «Уран»	item.arm.seva.name	armor/scientist	RANK_VETERAN
1546	zzy2y	Комбинезон «Жнец»	item.arm.jnec.name	armor/scientist	RANK_VETERAN
1547	5lrn1	Tяжелый бронекостюм «Восход»	item.arm.voshod.name	armor/combat	RANK_VETERAN
1548	y352k	Tяжелый бронекостюм «Громила»	item.arm.gromila.name	armor/combat	RANK_VETERAN
1549	wjg72	КИМ-99 «Янтарь»	item.arm.yantar.name	armor/scientist	RANK_STALKER
1550	4qlnr	КИМ-99М «Малахит»	item.arm.kimm.name	armor/scientist	RANK_VETERAN
1551	knqvy	Бронекостюм «Сокол»	item.arm.sokol.name	armor/combined	RANK_STALKER
1552	qjogj	Бронекостюм «Пересмешник»	item.arm.mocking.name	armor/combined	RANK_STALKER
1553	j5kv0	Костюм АО-2 «Странник»	item.arm.ao2.name	armor/combined	RANK_NEWBIE
1554	lyjvk	Костюм АО-3 «Искатель»	item.arm.ao3.name	armor/combined	RANK_STALKER
1555	rwnzv	КИМ-105 «Топаз»	item.arm.topaz.name	armor/scientist	RANK_STALKER
1556	0r4q9	КИМ-113 «Иолит»	item.arm.iolit.name	armor/scientist	RANK_STALKER
1557	m06vy	КИМ-116 «Изумруд»	item.arm.izumrud.name	armor/scientist	RANK_STALKER
1558	ok096	КИМ-122 «Аметист»	item.arm.ametist.name	armor/scientist	RANK_VETERAN
1559	n4r21	КИМ-Х «АТЛАС»	item.arm.atlas.name	armor/scientist	RANK_MASTER
1560	p6m1w	УКАЗ АО-4 «Рейдер»	item.arm.ao4.name	armor/combined	RANK_VETERAN
1561	vj14r	УКАЗ АО-5 «Пилигрим»	item.arm.ao5.name	armor/combined	RANK_VETERAN
1562	dmgvj	Защитный костюм «Ош»	item.arm.osh.name	armor/combat	RANK_VETERAN
1563	2oqll	Экзоброня «Егерь»	item.arm.eger.name	armor/combat	RANK_VETERAN
1564	7lm56	Экзоскелет «Самсон»	item.arm.exo.name	armor/combat	RANK_VETERAN
1565	6w0zp	Экзоскелет «Масть»	item.arm.exo_bandit.name	armor/combat	RANK_VETERAN
1566	zzyly	Бронекостюм «Скиф-2м»	item.arm.bulat.name	armor/combined	RANK_VETERAN
1567	y35jk	Бронекостюм «Скиф-4»	item.arm.skat9m.name	armor/combined	RANK_VETERAN
1568	wjg62	Тяжелый бронекостюм «Легионер»	item.arm.legion.name	armor/combat	RANK_VETERAN
1569	4ql1r	Бронескелет «Центурион»	item.arm.centurion.name	armor/combat	RANK_MASTER
1570	m06k2	Бронекостюм «Скиф-5»	item.arm.skat10.name	armor/combined	RANK_MASTER
1571	zzy9m	Экзоскелет «Абориген»	item.arm.abo.name	armor/combat	RANK_VETERAN
1572	5lr4q	Защитный бронекостюм «Йорш»	item.arm.yorsh.name	armor/combat	RANK_VETERAN
1573	y35l3	УКАЗ «Спаннер»	item.arm.spanner.name	armor/combined	RANK_VETERAN
1574	wjgq3	КИМ-85Д	item.arm.kim85.name	armor/scientist	RANK_STALKER
1575	4qlwo	Бронекостюм «Булат-М»	item.arm.bulatm.name	armor/combined	RANK_VETERAN
1576	knq0p	Бронекостюм «Рысь»	item.arm.ris.name	armor/combat	RANK_STALKER
1577	qjoz3	Экзоскелет «Медведь»	item.arm.bear.name	armor/combat	RANK_VETERAN
1578	j5krg	Бронекостюм «Призрачный охотник»	item.arm.ghost.name	armor/combat	RANK_VETERAN
1579	0r4gy	Костюм «Экспедиция»	item.arm.expedition.name	armor/combined	RANK_VETERAN
1580	p6mg4	Экзоброня «Крысолов»	item.arm.ratcatcher.name	armor/combat	RANK_VETERAN
1581	dmgw2	Маскировочный костюм	item.arm.ghillie.name	armor/combat	RANK_NEWBIE
1582	1rkz2	Бронекостюм «Армай»	item.arm.armai.name	armor/combined	RANK_VETERAN
1583	g4yq5	Экзоскелет «Гренадер»	item.arm.grenadier.name	armor/combat	RANK_VETERAN
1584	96nrq	Модная куртка	item.arm.kyrtka_modnaya.name	armor/clothes	DEFAULT
1585	g4y3n	Комбинезон «КЗ-1»	item.arm.kz1.name	armor/combat	RANK_NEWBIE
1586	zzyjk	Бронекостюм «КЗ-2»	item.arm.kz2.name	armor/combat	RANK_NEWBIE
1587	y35q0	Пальто со шляпой	item.arm.palto.name	armor/clothes	DEFAULT
1588	96ngz	Продвинутый ОЗК	item.arm.ozk.name	armor/scientist	RANK_NEWBIE
1589	1rkn1	Комбинезон «Магнит»	item.arm.magnit.name	armor/scientist	RANK_VETERAN
1590	g4y5p	Бронекостюм «КЗ-3а»	item.arm.kz3a.name	armor/combat	RANK_STALKER
1591	zzy1n	Комплект «Алтын»	item.arm.altyn.name	armor/combat	RANK_STALKER
1592	5lr20	Бронекостюм «КЗ-3б»	item.arm.kz3b.name	armor/combat	RANK_VETERAN
1593	y359o	Тяжелый бронекостюм «Туманный охотник»	item.arm.smog.name	armor/combat	RANK_VETERAN
1594	wjg2o	Тяжелый комплект «Алтын-Т»	item.arm.heavyaltyn.name	armor/combat	RANK_VETERAN
1595	4qldn	Комбинезон «Тонга»	item.arm.tonga.name	armor/scientist	RANK_VETERAN
1596	knqkv	Бронескелет «Альбатрос-Разведчик»	item.arm.albatros_scout.name	armor/combined	RANK_VETERAN
1597	qjomk	Тяжелый бронекостюм «Идущий в метели»	item.arm.frostwalker.name	armor/combat	RANK_VETERAN
1598	g43rp	Экзоброня JD ZIVCAS 2A	item.arm.zivcas.name	armor/combined	RANK_MASTER
1599	zzjgn	Бронескелет «Альбатрос-Лазутчик»	item.arm.albatros_light.name	armor/combined	RANK_VETERAN
1600	5l1q0	Экзоскелет «Гектор»	item.arm.exo_mod.name	armor/combat	RANK_MASTER
1601	y3q1o	SBA TANK	item.arm.tank.name	armor/combat	RANK_MASTER
1602	wj4no	Бронескелет «Альбатрос-Штурмовик»	item.arm.albatros_heavy.name	armor/combined	RANK_LEGEND
1603	kn3yv	Комбинезон «Ригель»	item.arm.rigel.name	armor/combined	RANK_MASTER
1604	qj1lk	Бронекостюм «КЗ-4»	item.arm.kz4.name	armor/combat	RANK_MASTER
1605	ly3w1	Экзокостюм «Антарес»	item.arm.antares.name	armor/scientist	RANK_MASTER
1606	rwgl5	КИМ-100 «Гранат»	item.arm.granat.name	armor/scientist	RANK_STALKER
1607	0rnw1	КИМ-102 «Циркон»	item.arm.cirkon.name	armor/scientist	RANK_STALKER
1608	m03w7	Бронекостюм ZIVCAS M2-C	item.arm.zivcas_commander.name	armor/combined	RANK_LEGEND
1609	ok3q0	Бронескелет «Альбатрос-Перехватчик»	item.arm.albatros_interceptor.name	armor/combined	RANK_MASTER
1610	7lzl7	Комбинезон «Навигатор»	item.arm.navigator.name	armor/scientist	RANK_MASTER
1611	6wgwy	Бронекостюм «Ронин»	item.arm.ronin.name	armor/combat	RANK_MASTER
1612	96y6z	Экзокостюм «Миссионер»	item.arm.missioner.name	armor/combined	RANK_MASTER
1613	1rpr1	Бронекостюм «Храмовник»	item.arm.templar.name	armor/combat	RANK_MASTER
1614	g434p	Комбинезон «Ковчег»	item.arm.ark.name	armor/scientist	RANK_MASTER
1615	zzjzn	Экзоброня «Следак»	item.arm.investigator.name	armor/combined	RANK_MASTER
1616	5l1l0	Комбинезон «Орион»	item.arm.orion.name	armor/scientist	RANK_MASTER
1617	y3q3o	Бронекостюм «Прометей»	item.arm.prometheus.name	armor/combat	RANK_MASTER
1618	2ovr0	Комбинезон «Сатурн»	item.arm.saturn.name	armor/scientist	RANK_MASTER
1619	g43k0	Экзоскелет «Мул»	item.arm.mule.name	armor/combat	RANK_MASTER
1620	zzjk2	Экзоскелет «Туз»	item.arm.tuz.name	armor/combat	RANK_MASTER
1621	5l1yg	УКАЗ АО-6 «Кочевник»	item.arm.ao6.name	armor/combined	RANK_MASTER
1622	wj49p	Экзоброня «Зверобой»	item.arm.zveroboi.name	armor/combat	RANK_MASTER
1623	ly3kj	Сверхтяжелый бронекостюм «Апостол»	item.arm.apostle.name	armor/combat	RANK_MASTER
1624	rwgmg	Экзокостюм «Гончий»	item.arm.hound.name	armor/combined	RANK_MASTER
1625	0rn7d	Бронекостюм «Авангард»	item.arm.vanguard.name	armor/combat	RANK_MASTER
1626	m034j	Бронекостюм «Каратель»	item.arm.punisher.name	armor/combined	RANK_MASTER
1627	96yz0	Сверхтяжелый бронекостюм «Рейтар»	item.arm.reiter.name	armor/combat	RANK_MASTER
1628	1rpl6	Сверхтяжелый бронекостюм «Гранит»	item.arm.granite.name	armor/combat	RANK_MASTER
1629	g4310	Сверхтяжелый бронекостюм «Вождь»	item.arm.chieftain.name	armor/combat	RANK_MASTER
1630	wj4lp	Комбинезон «Пересвет»	item.arm.peresvet.name	armor/scientist	RANK_MASTER
1631	rwg9l	Штурмовой ПНВ	item.device.nvdtest2_1.name	armor/device	DEFAULT
1632	0rn6r	Штурмовой ПНВ	item.device.nvdtest2_8.name	armor/device	RANK_STALKER
1633	m03nr	Штурмовой ПНВ	item.device.nvdtest2_17.name	armor/device	RANK_VETERAN
1634	p69o5	Штурмовой ПНВ (зеленый)	item.device.nvdtest2_24g.name	armor/device	RANK_MASTER
1635	2ovwm	Штурмовой ПНВ (белый)	item.device.nvdtest2_24w.name	armor/device	RANK_MASTER
1636	3gd2k	Штурмовой ПНВ (синий)	item.device.nvdtest2_24b.name	armor/device	RANK_MASTER
1637	7lzdr	Сломанный ПНВ	item.device.nvd_broken.name	armor/device	DEFAULT
1638	6wgj6	Aww Scary NVD	item.device.nvd_aww.name	armor/device	DEFAULT
1639	96430	Аптечка индивидуальная	item.med.apt_i.name	medicine	DEFAULT
1640	1r2o6	Аптечка ученых	item.med.apt_s.name	medicine	RANK_STALKER
1641	g4lk0	Военная аптечка	item.med.apt_a.name	medicine	DEFAULT
1642	zzqk2	Бинт	item.med.bandage.name	medicine	DEFAULT
1643	5lzyg	«Гемостат»	item.med.barvinok.name	medicine	DEFAULT
1644	y3kgz	Антирад Б-191	item.med.antirad_1.name	medicine	DEFAULT
1645	wjw9p	Антирад Б-292	item.med.antirad_2.name	medicine	RANK_STALKER
1646	4qgop	Антирад Б-393	item.med.antirad_3.name	medicine	RANK_VETERAN
1647	kno60	Пси-блок «Нейрон-22»	item.med.psiblock_2.name	medicine	RANK_STALKER
1648	qj9y6	Антидот второго класса	item.med.antidot_2.name	medicine	RANK_STALKER
1649	j5mn7	«Термобарьер» второго класса	item.med.thermobarier_2.name	medicine	RANK_STALKER
1650	lynkj	Энергетик «Жидень EXTRA»	item.med.jiden.name	medicine	RANK_STALKER
1651	rw1mg	Тоник «Арни»	item.med.gerkules.name	medicine	RANK_STALKER
1652	0rd7d	Радиопротектор первого класса	item.med.protector_1.name	medicine	DEFAULT
1653	m0p4j	Радиопротектор второго класса	item.med.protector_2.name	medicine	RANK_STALKER
1654	okd4o	Радиопротектор третьего класса	item.med.protector_3.name	medicine	RANK_VETERAN
1655	n4vw6	Мазь от ожогов	item.med.mazz.name	medicine	RANK_STALKER
1656	p62q6	Морфин	item.med.morphin.name	medicine	RANK_VETERAN
1657	vjy3n	Эпинефрин	item.med.epinephrine.name	medicine	RANK_VETERAN
1658	dmky5	«ClearMind+»	item.med.clearmind.name	medicine	RANK_VETERAN
1659	2o900	Водка «Морозная»	item.med.vodka_ny.name	drink	RANK_MASTER
1660	3g1qz	Водка	item.med.vodka.name	drink	DEFAULT
1661	7ly13	Аптечка проводника	item.med.apt_p.name	medicine	RANK_VETERAN
1662	6w59j	«УДАР»	item.med.strike.name	medicine	RANK_VETERAN
1663	964z0	Водка «Кривой Коготь»	item.med.vodka_hw.name	drink	RANK_VETERAN
1664	1r2l6	«Астрикцин»	item.med.astrikcin.name	medicine	RANK_VETERAN
1665	g4l10	Анаболик «ATLAS»	item.med.atlas.name	medicine	RANK_VETERAN
1666	y3knz	«Убийца Боли»	item.med.painblocker.name	medicine	RANK_MASTER
1667	knop0	Яблочный сидр	item.med.cider_hw.name	drink	RANK_STALKER
1668	qj9q6	Пси-блок «Нейрон-33»	item.med.psiblock_3.name	medicine	RANK_VETERAN
1669	j5mq7	Антидот первого класса	item.med.antidot_1.name	medicine	DEFAULT
1670	lynrj	Антидот третьего класса	item.med.antidot_3.name	medicine	RANK_VETERAN
1671	rw1vg	«Термобарьер» первого класса	item.med.thermobarier_1.name	medicine	DEFAULT
1672	0rdld	«Термобарьер» третьего класса	item.med.thermobarier_3.name	medicine	RANK_VETERAN
1673	m0pqj	Пси-блок «Нейрон-11»	item.med.psiblock_1.name	medicine	DEFAULT
1674	okdpo	«Веселый лимонад»	item.med.lemonade.name	drink	RANK_VETERAN
1675	n4vg6	«Рассол»	item.med.brine.name	drink	RANK_VETERAN
1676	p6256	«Панацея»	item.med.detox.name	medicine	RANK_MASTER
1677	vjy0n	«Шапочка из фольги»	item.med.tinfoil_hat.name	drink	RANK_MASTER
1678	dmk65	Праздничный пунш	item.med.birthday_punch.name	drink	RANK_STALKER
1679	2o9g0	«Озверин»	item.med.ozverin.name	medicine	RANK_VETERAN
1680	3g1zz	«Субтропики»	item.med.subtropics.name	drink	RANK_MASTER
1681	7lyo3	«Алкобык»	item.med.alcobull.name	drink	RANK_MASTER
1682	6w5lj	«ШизоЁрш»	item.med.schizoyorsh.name	medicine	RANK_MASTER
1683	964k0	Сильная мазь от ожогов	item.med.advanced_mazz.name	medicine	RANK_MASTER
1684	1r216	«ТОПОТ»	item.med.stomping.name	medicine	RANK_MASTER
1685	1r246	Хорог	item.med.inside_goroh.name	food	RANK_MASTER
1686	g4lp0	Измененный сидр	item.med.inside_cider.name	drink	RANK_VETERAN
1687	zzqo2	Анаболик «SALT»	item.med.inside_salt.name	medicine	RANK_MASTER
1688	5lz3g	Дольки мандарина	item.food.ny23.mandarin_slice.name	food	RANK_NEWBIE
1689	y3kyz	Стаканчик мороженого	item.food.ny23.icecream_stakan.name	food	RANK_NEWBIE
1690	wjwzp	Детское шампанское	item.food.ny23.champagne_kids.name	drink	DEFAULT
1691	4qg3p	Бобы «С новым счастьем!»	item.food.ny23.beans.name	food	RANK_NEWBIE
1692	knoz0	Половинка мандарина	item.food.ny23.mandarine_half.name	food	RANK_NEWBIE
1693	qj9n6	Пломбир	item.food.ny23.icecream.name	food	RANK_STALKER
1694	j5mg7	Игристое шампанское	item.food.ny23.champagne_fizzy.name	drink	RANK_NEWBIE
1695	lyn5j	Фасоль «Рождественская»	item.food.ny23.beans_christmas.name	food	RANK_STALKER
1696	rw1pg	Свежий мандарин	item.food.ny23.mandarin.name	food	RANK_STALKER
1697	0rdjd	Шоколадный пломбир	item.food.ny23.icecream_chocolate.name	food	RANK_STALKER
1698	m0pyj	Аномальное шампанское	item.food.ny23.champagne_anomal.name	drink	RANK_STALKER
1699	okdno	Кукуруза «Сладкий декабрь»	item.food.ny23.corn.name	food	RANK_VETERAN
1700	n4vo6	Аномальный мандарин	item.food.ny23.mandarin_anomal.name	food	RANK_VETERAN
1701	p62o6	Эскимо	item.food.ny23.eskimo.name	food	RANK_VETERAN
1702	vjy5n	Советское шампанское	item.food.ny23.champagne_soviet.name	drink	RANK_VETERAN
1703	dmk95	Горох «Прошлогодний»	item.food.ny23.peas_old.name	food	RANK_VETERAN
1704	2o9w0	Грог	item.food.blizzard.grog.name	drink	RANK_MASTER
1705	3g12z	Жаркое из мутантов	item.food.blizzard.roast.name	food	RANK_VETERAN
1706	7lyd3	Анаболик «STARK»	item.food.blizzard.stark.name	medicine	RANK_MASTER
1707	6w5jj	Брусничная водка	item.food.blizzard.vodka.name	drink	RANK_MASTER
1708	g4lz0	«Биозаплатка»	item.med.sas.name	medicine	RANK_MASTER
1709	zzqn2	Нейротоник	item.med.bady_tonic.name	medicine	RANK_VETERAN
1710	964ow	Энергетик «Батарейка»	item.med.bady_energy.name	medicine	RANK_VETERAN
1711	1r2yq	Силовой стимулятор	item.med.stimulyator.name	medicine	RANK_MASTER
1712	g4lzg	Водка «Гейзер»	item.med.vodka_geyser.name	drink	RANK_MASTER
1713	zzqn9	Коктейль «Незабываемый»	item.med.unforgettable_mix.name	drink	RANK_MASTER
1714	96gqz	Кусок белого хлеба	item.food.bread_w.name	food	DEFAULT
1715	1rn01	Кусок черного хлеба	item.food.bread_b.name	food	DEFAULT
1716	g45rp	Мандарин	item.food.mandarin.name	food	DEFAULT
1717	y391o	Колбасная нарезка	item.food.kolbasa.name	food	RANK_NEWBIE
1718	wj2no	Армейские галеты	item.food.kreker.name	food	RANK_NEWBIE
1719	qjmlk	Бутерброд с икрой	item.food.buter_ikra.name	food	RANK_NEWBIE
1720	j54p6	Бутерброд с колбасой	item.food.buter_w_kolbasa.name	food	RANK_NEWBIE
1721	ly6w1	Бутерброд с колбасой	item.food.buter_b_kolbasa.name	food	RANK_NEWBIE
1722	rwol5	Консервированная фасоль	item.food.beans.name	food	RANK_NEWBIE
1723	0row1	Рыбные консервы	item.food.fish.name	food	RANK_NEWBIE
1724	m0jw7	Шпроты	item.food.shproti.name	food	RANK_STALKER
1725	okrq0	Мясные консервы	item.food.meat.name	food	RANK_NEWBIE
1726	n4l63	Вареный тунец	item.food.tunec.name	food	RANK_STALKER
1727	p60k2	Салат крабовый	item.26517.name	food	RANK_NEWBIE
1728	vjdqd	Салат оливье	item.food.olivie.name	food	RANK_VETERAN
1729	dm1ln	Красная икра	item.food.caviar.name	food	RANK_NEWBIE
1730	2opo6	«Радость туриста»	item.food.turist.name	food	RANK_STALKER
1731	3gvgg	Паштет «Собачья радость»	item.food.dogjoy.name	food	RANK_STALKER
1732	7l9l7	Холодец «Копытом по лицу»	item.food.holodec.name	food	RANK_VETERAN
1733	6w3wy	Консервы «Псиный визг»	item.food.dogscream.name	food	RANK_NEWBIE
1734	96g6z	Салат «Осьминожая свежесть»	item.food.octopus.name	food	RANK_NEWBIE
1735	1rnr1	«Шедевральная красота»	item.food.masterpiece.name	food	RANK_NEWBIE
1736	wj2jo	Американский ИРП	item.food.irp_usa.name	food	RANK_VETERAN
1737	4qdqn	Отечественный ИРП	item.food.irp.name	food	RANK_MASTER
1738	qjmjk	Боевой горох	item.food.peas_fighter.name	food	RANK_NEWBIE
1739	j5456	Отличная тушенка	item.food.excellent_stew.name	food	RANK_STALKER
1740	ly6y1	Завтрак чемпиона	item.food.champion_breakfast.name	food	RANK_MASTER
1741	rwow5	Бутылка чистой воды	item.med.water.name	drink	DEFAULT
1742	rwoj5	Лимон	item.26560.name	food	RANK_LEGEND
1743	n4lg6	Пшенка с мясом	item.food.millet_with_meat.name	food	RANK_VETERAN
1744	p6056	Каша гороховая с мясом	item.food.peas_with_meat.name	food	RANK_MASTER
1745	dm165	Макароны по-флотски	item.food.pasta_with_meat.name	food	RANK_VETERAN
1746	2opg0	Заливное	item.food.aspic.name	food	RANK_MASTER
1747	zz1o2	Фасолевый суп	item.food.bean_soup.name	food	RANK_VETERAN
1748	5l23g	Солянка	item.food.hot_soup.name	food	RANK_MASTER
1749	y39yz	Гороховый суп	item.food.peas_soup.name	food	RANK_MASTER
1750	wj2zp	Чесночный суп	item.food.garlic_soup.name	food	RANK_MASTER
1751	4qd3p	Уха из сома «Дворянская»	item.food.fish_soup.name	food	RANK_MASTER
1752	m0jyj	Премиум на 1 день	item.premium_token.desc	other	RANK_LEGEND
1753	okrno	Премиум на 2 дня	item.premium_token.desc	other	RANK_LEGEND
1754	n4lo6	Премиум на 3 дня	item.premium_token.desc	other	RANK_LEGEND
1755	p60o6	Премиум на 5 дней	item.premium_token.desc	other	RANK_LEGEND
1756	vjd5n	Премиум на 7 дней	item.premium_token.desc	other	RANK_LEGEND
1757	dm195	Премиум на 14 дней	item.premium_token.desc	other	RANK_LEGEND
1758	2opw0	Премиум на 30 дней	item.premium_token.desc	other	RANK_LEGEND
1759	3gv2z	Премиум на 90 дней	item.premium_token.desc	other	RANK_LEGEND
1760	7l9d3	Премиум на 180 дней	item.premium_token.desc	other	RANK_LEGEND
1761	rw32l	Ледяной осколок	item.misc.blizzard_iceshard.name	other	RANK_VETERAN
1762	0r52r	Ветка рябины	item.misc.blizzard_rowan.name	other	RANK_VETERAN
1763	m0lmr	Ипсилон данные	item.misc.blizzard_upsilon.name	other	RANK_VETERAN
1764	drmwj	Технический спирт	item.med.spirt.name	drink	DEFAULT
1765	00rny	Фракционный талон	item.quest.fractional_coupon.name	other	QUEST_ITEM
1766	w3923	Сменный аккумулятор	item.filler.npc_7.name	misc	RANK_NEWBIE
1767	77w9j	Резонатор	item.filler.mining_3.name	misc	DEFAULT
1768	9d3gy	Медная катушка	item.filler.mining_5.name	misc	DEFAULT
1769	19on2	Трансформатор	item.filler.mining_6.name	misc	DEFAULT
1770	z3k1m	Малый артефактный фрагмент	item.filler.node_1.name	misc	DEFAULT
1771	55ymq	Обычный артефактный фрагмент	item.filler.node_2.name	misc	DEFAULT
1772	w39k3	Огромный артефактный фрагмент	item.filler.node_4.name	misc	DEFAULT
1773	dryl2	Селезенка мутанта из Любеча	item.filler.mob_limansk_8.name	misc	DEFAULT
1774	21065	Сердце мутанта из Любеча	item.filler.mob_limansk_9.name	misc	DEFAULT
1775	55olq	Остатки приборов «Шепота»	item.filler.npc_limansk_7.name	misc	DEFAULT
1776	l0ryo	Черная селезенка	item.filler.boss_limansk_4.name	misc	DEFAULT
1777	rjvwy	Сердце Лимб	item.filler.boss_limansk_5.name	misc	DEFAULT
1778	9dknl	Болотный камень	item.brt.bolota.npc.name	other	DEFAULT
1779	191kg	Зеленая плесень	item.brt.bolota.mob.name	other	DEFAULT
1780	gn9y6	Камень Водяного	item.brt.bolota.npc_add.name	other	DEFAULT
1781	z30yy	Камышовый грибок	item.brt.bolota.mob_add.name	other	DEFAULT
1782	y405k	Семечки	item.brt.kordon.npc.name	other	DEFAULT
1783	w30g2	Корень-вонючка	item.brt.kordon.mob.name	other	RANK_NEWBIE
1784	4k5lr	Кулек	item.brt.kordon.npc_add.name	other	DEFAULT
1785	kr53y	Корень-липучка	item.brt.kordon.mob_add.name	other	RANK_NEWBIE
1786	j0z30	Срачник	item.brt.svalka.npc.name	other	RANK_NEWBIE
1787	l093k	Ржавая плесень	item.brt.svalka.mob.name	other	DEFAULT
1788	rj6gv	Остатки медной проволоки	item.brt.svalka.mining.name	other	RANK_NEWBIE
1789	009n9	Полыхающий срачник	item.brt.svalka.npc_add.name	other	RANK_NEWBIE
1790	mr13y	Ржавый мухомор	item.brt.svalka.mob_add.name	other	DEFAULT
1791	olz36	Моток медной проволоки	item.brt.svalka.mining_add.name	other	RANK_NEWBIE
1792	kr5oy	Остатки алюминиевого кабеля	item.brt.td.mining.name	other	DEFAULT
1793	q039j	Алюминиевый кабель	item.brt.td.mining_add.name	other	DEFAULT
1794	nkgv1	Кусок адского угля	item.brt.les.npc.name	other	DEFAULT
1795	pj52w	Росток чернобыльской ромашки	item.brt.les.mob.name	other	RANK_STALKER
1796	vn0yr	Остатки радиопередатчика	item.brt.les.mining.name	other	RANK_STALKER
1797	21g9l	Адский уголь	item.brt.les.npc_add.name	other	DEFAULT
1798	34z1l	Чернобыльская ромашка	item.brt.les.mob_add.name	other	RANK_STALKER
1799	77oy6	Остатки сигнального процессора	item.brt.les.mining_add.name	other	RANK_STALKER
1800	gn9l6	Рассольник	item.brt.bar.npc.name	other	RANK_STALKER
1801	z30qy	Синие дрожжи	item.brt.bar.mob.name	other	DEFAULT
1802	556z1	Фрагмент данных «Альфа»	item.brt.bar.node.name	other	RANK_STALKER
1803	y40kk	Крупный рассольник	item.brt.bar.npc_add.name	other	RANK_STALKER
1804	w30w2	Беличьи дрожжи	item.brt.bar.mob_add.name	other	DEFAULT
1805	4k5gr	Блок данных «Альфа»	item.brt.bar.node_add.name	other	RANK_STALKER
1806	kr5ky	Маячок группы «Альфа»	item.brt.bar.signal.name	other	RANK_STALKER
1807	rj6ov	Хлорник	item.brt.mg.npc.name	other	DEFAULT
1808	009o9	Подозоновик	item.brt.mg.mob.name	other	DEFAULT
1809	mr1jy	Остатки научного оборудования	item.brt.mg.mining.name	other	DEFAULT
1810	olzr6	Фрагмент данных «Бета»	item.brt.mg.node.name	other	RANK_VETERAN
1811	nkgl1	Формалин	item.brt.mg.npc_add.name	other	DEFAULT
1812	pj50w	Черный подозоновик	item.brt.mg.mob_add.name	other	DEFAULT
1813	vn0dr	Жесткие диски	item.brt.mg.mining_add.name	other	DEFAULT
1814	dr61j	Блок данных «Бета»	item.brt.mg.node_add.name	other	RANK_VETERAN
1815	21gpl	Маячок группы «Бета»	item.brt.mg.signal.name	other	RANK_STALKER
1816	77o96	Дурман-камень	item.brt.pd.npc.name	other	RANK_VETERAN
1817	6ol3p	Северный мох	item.brt.pd.mob.name	other	RANK_VETERAN
1818	9dkgl	Остатки аккумуляторов	item.brt.pd.mining.name	other	RANK_VETERAN
1819	191ng	Фрагмент данных «Гамма»	item.brt.pd.node.name	other	RANK_MASTER
1820	gn956	Камень Жмых-Вжух-Плюх	item.brt.pd.npc_add.name	other	RANK_VETERAN
1821	z301y	Цветущий северный мох	item.brt.pd.mob_add.name	other	RANK_VETERAN
1822	55621	Армейский аккумулятор	item.brt.pd.mining_add.name	other	RANK_VETERAN
1823	y409k	Блок данных «Гамма»	item.brt.pd.node_add.name	other	RANK_MASTER
1824	w3022	Маячок группы «Гамма»	item.brt.pd.signal.name	other	RANK_STALKER
1825	kr54y	Рачки	item.brt.armsklad.npc.name	other	DEFAULT
1826	q03dj	Кислотная крапива	item.brt.armsklad.mob.name	other	DEFAULT
1827	j0zy0	Поврежденные микросхемы	item.brt.armsklad.mining.name	other	DEFAULT
1828	l09qk	Фрагмент данных «Дельта»	item.brt.armsklad.node.name	other	DEFAULT
1829	rj63v	Барбариска	item.brt.armsklad.npc_add.name	other	DEFAULT
1830	00959	Дьявольская крапива	item.brt.armsklad.mob_add.name	other	DEFAULT
1831	mr1ly	Целые микросхемы	item.brt.armsklad.mining_add.name	other	DEFAULT
1832	olzo6	Блок данных «Дельта»	item.brt.armsklad.node_add.name	other	DEFAULT
1833	vn0wr	Вещество 07270	item.brt.sever.npc.name	other	RANK_MASTER
1834	dr6nj	Рыжий папоротник	item.brt.sever.mob.name	other	RANK_MASTER
1835	21gkl	Остатки пси-маячка	item.brt.sever.mining.name	other	RANK_MASTER
1836	34zjl	Фрагмент данных «Дигамма»	item.brt.sever.node.name	other	DEFAULT
1837	77ov6	Квантовая батарея	item.brt.sever.airdrop.name	other	RANK_MASTER
1838	6olnp	Светящаяся слизь	item.brt.sever.fallout.name	other	DEFAULT
1839	9dk7l	Аномальная сыворотка	item.brt.sever.capture.name	other	RANK_MASTER
1840	gn976	Очищенное вещество 07270	item.brt.sever.npc_add.name	other	RANK_MASTER
1841	z30my	Цветущий рыжий папоротник	item.brt.sever.mob_add.name	other	RANK_MASTER
1842	9dk7y	Пси-маячок	item.brt.sever.mining_add.name	other	RANK_MASTER
1843	191w2	Блок данных «Дигамма»	item.brt.sever.node_add.name	other	DEFAULT
1844	gn975	Портативный квантовый генератор	item.brt.sever.airdrop_add.name	other	RANK_MASTER
1845	z30mm	Записи майора Д.	item.brt.sever.capture_add.name	other	DEFAULT
1846	553qq	Ядерный желатин	item.brt.sever.fallout_add.name	other	DEFAULT
1847	y4y13	Маячок группы «Дигамма»	item.brt.sever.signal.name	other	RANK_STALKER
1848	w3zn3	Боевой жетон	item.brt.battlefields.name	other	RANK_VETERAN
1849	4k3zo	Багровый жетон	item.brt.ffa_token.name	other	RANK_MASTER
1850	21365	Лимб	item.brt.limansk.npc.name	other	RANK_MASTER
1851	34305	Горьколистник	item.brt.limansk.mob.name	other	RANK_MASTER
1852	6o7m0	Фрагмент данных «Лямбда»	item.brt.limansk.node.name	other	RANK_MASTER
1853	9d1qy	Аномальная батарея	item.brt.limansk.airdrop.name	other	RANK_MASTER
1854	19402	Лимбоплазма	item.brt.limansk.boss.name	other	RANK_MASTER
1855	gnpr5	Темный Лимб	item.brt.limansk.npc_add.name	other	RANK_MASTER
1856	z3ogm	Расцветший Горьколистник	item.brt.limansk.mob_add.name	other	RANK_MASTER
1857	y4y33	Блок данных «Лямбда»	item.brt.limansk.node_add.name	other	RANK_MASTER
1858	w3zj3	Модифицированная аномальная батарея	item.brt.limansk.airdrop_add.name	other	RANK_MASTER
1859	4k3qo	Концентрированная лимбоплазма	item.brt.limansk.boss_add.name	other	RANK_MASTER
1860	krznp	Маячок группы «Лямбда»	item.brt.limansk.signal.name	other	RANK_STALKER
1861	pjn64	Ящик с ресурсами	item.misc.arsenal_box.name	other	RANK_VETERAN
1862	z3ozm	«Светящийся сахар»	item.clan.resource2.name	misc	RANK_STALKER
1863	194j1	Сумка патронов 12.7 мм	item.bag.127st.name	bullet	RANK_STALKER
1864	z3oln	Сумка снайперских 12.7 мм	item.bag.127snp.name	bullet	RANK_VETERAN
1865	kr2np	Часть АМ-17 #1	item.part.am17_1.name	misc	RANK_LEGEND
1866	q0pj3	Часть АМ-17 #2	item.part.am17_2.name	misc	RANK_MASTER
1867	j0w5g	Часть АМ-17 #3	item.part.am17_3.name	misc	RANK_VETERAN
1868	l0oyo	Часть АМ-17 #4	item.part.am17_4.name	misc	RANK_STALKER
1869	rj9wy	Часть Scorpion EVO III #1	item.part.scorpion_1.name	misc	RANK_LEGEND
1870	006ry	Часть Scorpion EVO III #2	item.part.scorpion_2.name	misc	RANK_MASTER
1871	mrn02	Часть Scorpion EVO III #3	item.part.scorpion_3.name	misc	RANK_VETERAN
1872	ol6km	Часть Scorpion EVO III #4	item.part.scorpion_4.name	misc	RANK_STALKER
1873	nko42	Часть SIG Sauer P320 #1	item.part.p320_1.name	misc	RANK_LEGEND
1874	pjo64	Часть SIG Sauer P320 #2	item.part.p320_2.name	misc	RANK_MASTER
1875	vn5jp	Часть SIG Sauer P320 #3	item.part.p320_3.name	misc	RANK_VETERAN
1876	dr9m2	Часть SIG Sauer P320 #4	item.part.p320_4.name	misc	RANK_STALKER
1877	21wo5	Часть VIKING Tactics #1	item.part.viking_1.name	misc	RANK_MASTER
1878	342g5	Часть VIKING Tactics #2	item.part.viking_2.name	misc	RANK_VETERAN
1879	77dlj	Часть VIKING Tactics #3	item.part.viking_3.name	misc	RANK_STALKER
1880	6ojw0	Часть Lantac BMD #1	item.part.lantac_bmd_1.name	misc	RANK_MASTER
1881	9do6y	Часть Lantac BMD #2	item.part.lantac_bmd_2.name	misc	RANK_VETERAN
1882	19yr2	Часть Lantac BMD #3	item.part.lantac_bmd_3.name	misc	RANK_STALKER
1883	gnz45	Часть ACOG 2x40 #1	item.part.acog2_1.name	misc	RANK_MASTER
1884	z3nzm	Часть ACOG 2x40 #2	item.part.acog2_2.name	misc	RANK_VETERAN
1885	55j5q	Часть ACOG 2x40 #3	item.part.acog2_3.name	misc	RANK_STALKER
1886	y4643	Часть DOTSAT #1	item.part.dotsat_1.name	misc	RANK_MASTER
1887	w3y33	Часть DOTSAT #2	item.part.dotsat_2.name	misc	RANK_VETERAN
1888	4kjko	Часть DOTSAT #3	item.part.dotsat_3.name	misc	RANK_STALKER
1889	kr2rp	Часть Lantac Dragon #1	item.part.lantac_dragon_1.name	misc	RANK_MASTER
1890	q0p03	Часть Lantac Dragon #2	item.part.lantac_dragon_2.name	misc	RANK_VETERAN
1891	j0w0g	Часть Lantac Dragon #3	item.part.lantac_dragon_3.name	misc	RANK_STALKER
1892	dr9r2	Часть Кувалды #1	item.part.sledgehammer_1.name	misc	RANK_LEGEND
1893	21w15	Часть Кувалды #2	item.part.sledgehammer_2.name	misc	RANK_MASTER
1894	34245	Часть Кувалды #3	item.part.sledgehammer_3.name	misc	RANK_VETERAN
1895	77d7j	Часть Кувалды #4	item.part.sledgehammer_4.name	misc	RANK_STALKER
1896	kr25j	Крупнокалиберный самодельный патрон	item.amm.12st_sessions.name	bullet	DEFAULT
1897	j0w96	Дешевые запчасти	item.upg.protector_1.name	other	RANK_NEWBIE
1898	l0og1	Стандартные запчасти	item.upg.protector_2.name	other	RANK_STALKER
\.


--
-- TOC entry 3409 (class 0 OID 0)
-- Dependencies: 235
-- Name: auction_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: db_user
--

SELECT pg_catalog.setval('public.auction_item_id_seq', 1898, true);


-- Completed on 2025-09-22 01:03:11 UTC

--
-- PostgreSQL database dump complete
--

\unrestrict nHPHgJklSKANp2sninrGF2QGEpLCvJUfsmxeqs9b9SDuXhN3k8RcXRYbbDA8QsR

