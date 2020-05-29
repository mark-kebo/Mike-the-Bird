# Mike-the-Bird
SpriteKit iOS 2D Game, Swift
-----

Krótki opis projektu wraz z zawartymi mechanizmami interakcji gracza z grą
-
W ramach projektu realizujemy grę pt. “Mike the Bird”, w której sterujemy ptakiem z gatunku Sultan Tit, aby pokonać jak najdłuższy dystans w malowniczych krajobrazach Borneo oddanych w atrakcyjnej pixelartowej estetyce. Kamera wraz ptakiem zawsze będącym w lewej części ekranu porusza się nieustannie - od startu ruchu do wylądowania ptaka. Gracz steruje ruchem ptakiem poprzez stukanie w ekran w odpowiednich momentach. Ptak musi omijać przeszkody, z którymi kolizja powoduje natychmiastową śmierć, oraz zbierać unoszące się w powietrzu przedmioty dodające energii niezbędnej do wykonywania ruchów utrzymujących w locie. 


Akcja
-
Ptak może się poruszać na trzy sposoby:
dwa lub więcej stuknięć w krótkim (ok. ¼ sekundy) czasie powoduje, o ile poziom energii jest większy niż 0, jednorazowe wzbicie się w górę (ruch po linii w kształcie sinusoidy dla x od 0 do 120 stopni). Następny taki ruch jest możliwy po zakończeniu bieżącego wzbijania się (czyli osiągnięcia punktu odpowiadającemu wartości sinusoidy dla 120 stopni - oznacza, że ruch ten nie może być przerwany na skutek jakiejkolwiek aktywności gracza.
przytrzymanie ekranu palcem powoduje szybowanie, o ile poziom energii jest większy niż 0 - ruch w linii prostej o lekko spadkowej tendencji (około 5 stopni względem linii poziomej).
brak dotyku ekranu lub gdy poziom energii równy jest 0 powoduje ruch w kierunku ziemi w linii prostej nachylonej o około 30 stopni względem linii prostej.



Przestrzeń
-
Przestrzeń, w której porusza się nasz bohater, jest więc ciągła i linearna - gracz decyduje o tym, w jakiej pozycji w pionie znajdzie się ptak. Ptak ma stałą prędkość w poziomie równą prędkości przesuwania się kamery i prędkość ta jest zawsze tak sama w każdym poziomie i na każdym etapie rozgrywki

Czas
-
Wraz z postępującym czasem rozgrywki planowane jest miarowe zwiększanie stopnia trudności poprzez dodanie liczby przeszkód, ustawianie ich w bardziej problematyczny sposób, a także rozstawianie jedzonek rzadziej (ale nigdy nie tak rzadko, żeby ptak umarł na skutek braku jedzenia do zebrania) i w trudniejszych do osiągnięcia pozycjach.
Na obecnym etapie projektowania ostrożnie jest założyć, że w trakcie gry pora dnia się nie zmienia. Natomiast jeśli wystarczy czasu i chęci, w celu zwiększenia atrakcyjności oraz urozmaicenia i podwyższenia wrażeń estetycznych, zespół postara się w trakcie rozgrywki zawrzeć zmianę krajobrazu w zależności od zmieniającego się światła, co obrazowałoby upływanie pór doby (np. stopniowe wschodzenie słońca). Czas upływałby szybciej niż w rzeczywistości - cykl dobowy wynosiłby w grze około 10 minut)/

Obiekty
-
Wyodrębnić można dwa rodzaje obiektów występujących w grze. Pierwszym są przeszkody i ich niezbędnym atrybutem będzie pozycja, rozmiar (czy też obszar, jaki zajmują). Kolizja gracza z nimi powoduje natychmiastową śmierć bohatera, a więc zarazem przegraną. Przeszkodami będą przedmioty stałe takie jak wystające gałęzie drzew, dachy domów, unoszące się w powietrzu balony itp. W zależności od zasobów i możliwości zespołu oraz z późniejszego określenia, czy będzie warto rozbudowywać rozgrywkę, możliwe będzie też umieszczenie przeszkód ruchomych, poruszających się z prędkością o stałej wartości, choć być może zmieniającymi trajektorię lotu w regularny sposób - byłyby to np. drony, inne ptaki, przeskakujące między drzewami małpki, sieci rzucone w naszym kierunku przez łowców rzadkich okazów itp.
Drugim typem obiektów będą unoszące się w powietrzu przedmioty do zabrania. Zawsze będą to przedmioty organiczne: czyli różnego rodzaju“jedzonka” - ziarenka zbóż, ryżu, insekty, robaczki - dodające nam określoną ilość energii - zatem ich atrybutami będzie pozycja, rozmiar i liczba punktów energii. Na etapie rozważań jest zawarcie w tym typie przedmiotów odejmujących punkty energii - byłyby to np. drobinki pyłu, unoszące się plamy brudnego industrialnego oleju. Będą one znikać i przynosić efekt w postaci dodanej graczowi odpowiedniej liczby punktów energii w momencie, gdy ptak przez nie przeleci (czyli, technicznie rzecz ujmując, gdy nastąpi kolizja). Planujemy dodać jakiś satysfakcjonujący efekt dźwiękowy i/lub wizualny.

Zasady
-
Zasady są proste: zadaniem gracza jest jak najdłuższy lot (w przypadku trybu “Leć jak najdłużej”) lub dotarcie do celu (w przypadku trybu story). Przegrana następuje na skutek kolizji z przeszkodami lub w zetknięciu z ziemią. Aby utrzymać poziom energii pozwalający na wykonywanie ruchów utrzymujących w locie, trzeba zbierać dodające punktów energii jedzonka. Poziom energii spada w trakcie rozgrywki w określonym tempie (np. -1 HP na sekundę). Gdy poziom energii wyniesie 0 nie jest możliwe szybowanie oraz wznoszenie się w górę - ptak nie reaguje na dotyk ekranu przez gracza, opada w linii prostej nachylonej pod kątem 30 stopni w dół aż do zderzenia z ziemią.


Umiejętności
-
Gracz w trakcie rozgrywki używa przede wszystkim umiejętności zręcznościowych: musi wykazać się refleksem i umiejętnością szacowania, aby stuknąć w ekran w odpowiednim momencie. Wymagania rozgrywki względem gracza obejmują także umiejętność planowania krótkoterminowego pod presją (czasową i tą wynikającą z zagrożenia przegranej).  


Szanse (okazje)
-
Elementami wzbogającymi rozgrywkę byłyby rzadkie pojawienie się ekstra jedzonek, bardziej rzucających się w oczy i dodających więcej punktów energii niż typowe. Luźnym, ewentualnym pomysłem jest niespodziewane pojawienie się w kryzysowym momencie (low energy level) kolegi-ptaka podobnego do naszego gatunku, tylko w innych kolorach - taki kolega wykonywałby jakąś czynność pomagającą nam - np. zrzucałby prosto na nas jedzonko ze swojego dzióbka.
	Rozważamy też zawarcie boosta, który polegałby na zwiększeniu prędkości o kilka sekund, w czasie których ptak byłby niezniszczalny i napotkane przedmioty tylko by rozwalał. Z pewnością byłby to element dodający poczucia satysfakcji i atrakcyjności, jednak może wymagać dużego nakładu pracy.
