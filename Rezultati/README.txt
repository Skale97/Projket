cc - sva merenja primljena od strane mikrokontrolera, raw podaci iz buffera. Format naziva M-x<vrednost x koordinate>y<vrednost y koordinate>z<vrednost z koordinate>b<redni broj merenja>cc.txt, gde je su prostorne pozicije merene u postavljenom koordinatnom sistemu, a vršeno je po 3 merenja u svakoj taèki. Podaci su odvojeni samo space-om, ima 40000 brojeva, sa 4 kanala, po 10000 sa svakog

CCToNM - uèitava prigodno formatirane podatke iz DataToCSV/CC.txt, i pokreæe Nelder Mead algoritam nad njima, i na kraju ispisuje u NM.txt fajl, tako da pra tri broja u redu predstavljaju stvarne x, y, i z koordinate, nakon èega slede procene pozicije pomoæu NM algoritma, za sva tri merenja

data - svi rezultati posle pokretanja algoritma, sliènog formatiranja kao i kod cc, sa razlikom što nema broja merenja u nazivu, jer su sva tri merenja sadržana u .txt fajlu. Sam sadržaj .txt fajla je intuitivan. U ovim fajlovima je sadržan samo rezultat pomoæu gradient descent metode, dok je rezultat pomoæu Nelder Meada sadržan u CCToNM/NM.txt, što je veæ opisano

Plotovanje processing -
	DATA_Plot - Live plot nekog mikrofona
	plt2D - Koristi se za plotovanje podataka u 2D,  
	plt3D - Jako zanimljiv naèin plotovanja 4D podataka u 3D kocki gde hue neke taèke predstavlja èetvrtu dimenziju, koristi se za plotovanje greške 3D simulacije
	Simplex_animation - animacija kretanja simplexa

All data sadrži sve podatke merenjenja, u prvom sheetu se nalaze rezultati kroskorelacije i GD i NM, a onda se u daljim sheetovima vrši obrata i izvlaèe neke potrebne informacije

Test signal je pravljen u Audacity-ju i puštan u audacity-ju