cc - sva merenja primljena od strane mikrokontrolera, raw podaci iz buffera. Format naziva M-x<vrednost x koordinate>y<vrednost y koordinate>z<vrednost z koordinate>b<redni broj merenja>cc.txt, gde je su prostorne pozicije merene u postavljenom koordinatnom sistemu, a vr�eno je po 3 merenja u svakoj ta�ki. Podaci su odvojeni samo space-om, ima 40000 brojeva, sa 4 kanala, po 10000 sa svakog

CCToNM - u�itava prigodno formatirane podatke iz DataToCSV/CC.txt, i pokre�e Nelder Mead algoritam nad njima, i na kraju ispisuje u NM.txt fajl, tako da pra tri broja u redu predstavljaju stvarne x, y, i z koordinate, nakon �ega slede procene pozicije pomo�u NM algoritma, za sva tri merenja

data - svi rezultati posle pokretanja algoritma, sli�nog formatiranja kao i kod cc, sa razlikom �to nema broja merenja u nazivu, jer su sva tri merenja sadr�ana u .txt fajlu. Sam sadr�aj .txt fajla je intuitivan. U ovim fajlovima je sadr�an samo rezultat pomo�u gradient descent metode, dok je rezultat pomo�u Nelder Meada sadr�an u CCToNM/NM.txt, �to je ve� opisano

Plotovanje processing -
	DATA_Plot - Live plot nekog mikrofona
	plt2D - Koristi se za plotovanje podataka u 2D,  
	plt3D - Jako zanimljiv na�in plotovanja 4D podataka u 3D kocki gde hue neke ta�ke predstavlja �etvrtu dimenziju, koristi se za plotovanje gre�ke 3D simulacije
	Simplex_animation - animacija kretanja simplexa

All data sadr�i sve podatke merenjenja, u prvom sheetu se nalaze rezultati kroskorelacije i GD i NM, a onda se u daljim sheetovima vr�i obrata i izvla�e neke potrebne informacije

Test signal je pravljen u Audacity-ju i pu�tan u audacity-ju