# Guida alla Scrittura della Relazione di Laboratorio

**Control Engineering Laboratory - Prof. Francesco Ticozzi**  
*Tecniche, Regole e Consigli Pratici*

---

> **Obiettivo della Relazione:** Dimostrare ciò che hai imparato dal corso attraverso una presentazione chiara e professionale del tuo lavoro di laboratorio.

## 1. Principi Fondamentali

### Prima di Iniziare a Scrivere

**Domande da Porsi:**
- **Cosa voglio comunicare?** Identifica chiaramente i risultati e cosa è necessario per supportarli
- **Chi è il lettore?** La relazione deve essere comprensibile a chiunque abbia una formazione matematica minima, ma dettagliata per chi ha seguito il corso
- **Qual è il messaggio essenziale?** Mostrare quello che hai fatto e quello che hai imparato

### Elementi Essenziali del Problema di Controllo

1. Sistema di interesse
2. Modello(i)
3. Prestazioni desiderate
4. Architettura di controllo scelta
5. Parametri del controllore progettato
6. Risultati delle simulazioni
7. Test nel mondo reale

## 2. Struttura della Relazione

| Parte | Contenuto | Pagine Max |
|-------|-----------|------------|
| **Parte 1** | Introduzione; Descrizione del sistema e del suo modello; Info autore, gruppo, numero motore | 2 |
| **Parte 2** | Metodologie e Risultati; Seguire la struttura degli assignment | 18 |
| **Parte 3** | Appendici; Informazioni non essenziali ma utili per approfondimenti | 10 |

> **💡 Consiglio:** Usa LaTeX con carattere dimensione 12. Se non conosci LaTeX, considera di impararlo - è lo standard per documenti tecnici e scientifici.

## 3. Preparazione alla Scrittura

### Lista di Controllo Pre-Scrittura

- [ ] Elenca accuratamente tutti i compiti richiesti e quelli extra
- [ ] Assicurati di avere tutti i dati necessari
- [ ] Evidenzia chiaramente se hai provato qualcosa di non standard e perché
- [ ] Usa questa lista come "scheletro" per le sezioni della relazione
- [ ] Organizza la logica dei contenuti prima di scrivere ogni sezione
- [ ] Prepara i grafici necessari per illustrare i risultati

> **⚠️ Importante:** Essere onesti è meglio. Elenca le difficoltà incontrate in ogni punto - possono aiutare a mostrare che comprendi gli aspetti chiave.

## 4. Descrizione del Sistema e del Modello

### Cosa Includere

- Breve riepilogo del sistema fisico e dei suoi componenti
- Identificazione chiara di ingressi, uscite, attuatori e sensori
- Un disegno o una foto con descrizioni aggiunte
- Modello matematico del sistema (senza derivazione)
- Definizione di tutte le variabili e simboli

**Esempio di descrizione:**
> "Il sistema considerato è un motore DC con encoder incrementale. L'ingresso u(t) rappresenta la tensione applicata al motore [V], mentre l'uscita y(t) è la velocità angolare misurata dall'encoder [rad/s]."

## 5. Descrizione dell'Identificazione e Progetto di Controllo

> **📋 Ricorda:** Non stai scrivendo un libro di testo! Specifica i metodi utilizzati e mostra le formule chiave (non le loro derivazioni).

### Linee Guida

- Sii conciso ma non omettere parti chiave
- Immagina di essere un lettore non esperto: può ricostruire quello che è stato fatto?
- Mantieni uno stile "scientifico"
- Usa frasi brevi: soggetto-verbo-complementi
- Evita costruzioni sintattiche italiane
- Evita gergo di laboratorio inappropriato

## 6. Regole Linguistiche

### Tempi Verbali

- **Presente:** per fatti generali o conoscenze consolidate
  - ✅ "L'acqua bolle a 100°C"
- **Passato:** per il tuo lavoro o risultati specifici
  - ✅ "Abbiamo condotto tre esperimenti"

### Vocabolario e Stile

- Preferisci vocabolario preciso e accademico
- Evita contrazioni: usa "non" invece di "non è"
- Usa parole di collegamento e transizione

**Parole di Collegamento Utili:**
- **Contrasto:** tuttavia, ciononostante, sebbene
- **Causa/effetto:** pertanto, quindi, di conseguenza, a causa di
- **Aggiungere informazioni:** inoltre, in aggiunta, per di più
- **Esempi:** per esempio, come, vale a dire

## 7. Punteggiatura

### Punti e Virgole

❌ "Perché la soluzione ha cambiato colore." (frase incompleta)  
✅ "La soluzione ha cambiato colore."

### Virgole

Usare per:
- Separare elementi in una lista
- Dopo parole/frasi introduttive
- Aggiungere informazioni extra (non essenziali)

❌ "La reazione è stata veloce, è finita in due secondi."  
✅ "La reazione è stata veloce. È finita in due secondi."

### Punto e Virgola

- Collegare due frasi indipendenti strettamente correlate
- Separare elementi complessi in una lista

### Due Punti

- Introdurre una lista, spiegazione o esempio
- Per enfatizzare o chiarire

❌ "I metalli sono: ferro, zinco, rame."  
✅ "I metalli sono ferro, zinco e rame."

### Trattini

Usa trattini per aggettivi composti (prima di un sostantivo):
- "Un metodo ben noto" → "Un metodo ben-noto"
- "Immagine ad alta risoluzione" → "Immagine ad alta-risoluzione"

✅ "Il metodo è ben noto." (dopo il sostantivo, niente trattino)

## 8. Formule e Notazioni Matematiche

### Linee Guida

- Mantieni una notazione coerente con quella vista nel corso
- Non tutti i passaggi di una derivazione sono necessari
- Tutti i simboli in una formula devono essere definiti
- **Le unità di misura sono importanti!**

**Esempio:**
> "La funzione di trasferimento del sistema è G(s) = K/(τs + 1), dove K è il guadagno statico [rad/s/V] e τ è la costante di tempo [s]."

## 9. Risultati e Grafici

### Presentazione dei Risultati

- Scrivi i risultati attesi/necessari dall'assignment
- Per un controllore, non basta un grafico di risposta al gradino - servono struttura, numeri, guadagni, funzione di trasferimento, schema a blocchi
- Presenta affiancati i test per il modello e per il sistema reale
- Usa tabelle per confrontare rapidamente indici di prestazione

### Grafici - Regole Fondamentali

> **🎯 Leggibilità è fondamentale**

- Assi con unità e intervalli appropriati ed evidenti
- Usa più risposte per grafico per confronti rapidi
- Legende, riquadri e didascalie per specificare cosa è cosa
- Colori e stili di linea diversi per dataset diversi
- Considera che potrebbe essere stampato in bianco e nero
- Se necessario, aggiungi sottofigure con versioni "zoomed-in"

**Esempio di didascalia:**
> "Risposta del sistema in anello chiuso a un gradino di 40°, con controllore PID emulato con Tustin e tempo di campionamento T=0.1, 0.01, 0.001 s."

## 10. Schemi Simulink

- Utili per capire cosa hai implementato
- Spesso troppo complicati per il testo principale - metti versioni semplificate nel testo, complete in appendice
- Includi se hai progettato architetture speciali
- Possono aiutare a spiegare comportamenti anomali
- Tutti i parametri usati devono essere presenti da qualche parte nella relazione

## 11. Appendici

- Dataset, derivazioni lunghe, schemi Simulink, codice MATLAB
- Non devono contenere informazioni chiave per seguire il lavoro
- Metti lì il codice MATLAB usato per calcolare i parametri
- Non sono automaticamente incluse nella valutazione

## 12. Consigli Aggiuntivi

### Revisione e Controllo Qualità

- **Rileggi ad alta voce:** aiuta a identificare frasi awkward e errori di punteggiatura
- **Controlla la coerenza:** stessa notazione, stesso stile, stessi colori nei grafici
- **Verifica i riferimenti:** ogni figura e tabella deve essere referenziata nel testo
- **Controllo ortografico:** usa strumenti automatici ma non affidarti solo a quelli

### Gestione del Tempo

> **⚠️ Attenzione:** La scrittura richiede più tempo di quanto pensi!

- Inizia presto
- Dedica tempo alla pianificazione prima di scrivere
- Prevedi tempo per multiple revisioni
- Non lasciare la formattazione per l'ultimo momento

### Collaborazione nel Gruppo

- Stabilisci chi scrive cosa all'inizio
- Mantieni uno stile uniforme tra le sezioni
- Usa strumenti di collaborazione (Google Docs, Overleaf per LaTeX)
- Prevedi tempo per l'integrazione e la revisione finale

### Strumenti Consigliati

- **LaTeX:** per documento professionale e formule matematiche
- **MATLAB:** per generare grafici di alta qualità
- **Grammarly/LanguageTool:** per controllo grammaticale
- **Mendeley/Zotero:** per gestione bibliografia (se necessaria)
- **Overleaf:** per collaborazione su LaTeX
- **Git/GitHub:** per controllo versione del codice

### Come Ottenere Grafici di Qualità in MATLAB

```matlab
% Esempio di codice per grafici professionali
figure('Position', [100, 100, 800, 600]);
plot(t, y1, 'b-', 'LineWidth', 2);
hold on;
plot(t, y2, 'r--', 'LineWidth', 2);
xlabel('Tempo [s]', 'FontSize', 12);
ylabel('Ampiezza [V]', 'FontSize', 12);
title('Risposta del Sistema', 'FontSize', 14);
legend('Simulazione', 'Esperimento', 'Location', 'best');
grid on;
set(gca, 'FontSize', 11);
```

### Gestione dei Dati e Riproducibilità

- Salva tutti i dati raw in formato organizzato
- Documenta i parametri usati per ogni esperimento
- Mantieni script MATLAB commentati e organizzati
- Crea script "master" che riproducono tutti i risultati
- Backup regolari del lavoro

## 13. Errori Comuni da Evitare

### Errori di Contenuto

- ❌ Non definire i simboli usati nelle formule
- ❌ Grafici senza unità sugli assi
- ❌ Risultati senza spiegazione del loro significato
- ❌ Copiare e incollare dalle istruzioni dell'assignment
- ❌ Non confrontare simulazione con esperimenti

### Errori di Forma

- ❌ Inconsistenza nella notazione
- ❌ Figure non referenziate nel testo
- ❌ Didascalie troppo brevi o assenti
- ❌ Paragrafi troppo lunghi
- ❌ Uso eccessivo di bullet point nel testo principale

### Errori di Stile

- ❌ Linguaggio troppo colloquiale
- ❌ Frasi troppo lunghe e complicate
- ❌ Ripetizioni eccessive
- ❌ Mancanza di collegamento tra le sezioni
- ❌ Conclusioni troppo generiche

## 14. Checklist Finale

**Prima di Consegnare:**

### Contenuto
- [ ] Tutti i compiti dell'assignment sono stati affrontati
- [ ] Tutti i simboli e variabili sono definiti
- [ ] I risultati principali sono evidenziati chiaramente
- [ ] Le difficoltà incontrate sono discusse onestamente
- [ ] C'è un'analisi critica dei risultati, non solo descrizione

### Formato e Stile
- [ ] Tutti i grafici hanno assi etichettati e unità
- [ ] Tutte le figure hanno didascalia descrittiva
- [ ] La numerazione di pagine, figure e tabelle è corretta
- [ ] Lo stile è consistente in tutto il documento
- [ ] Il documento rispetta i limiti di pagine

### Informazioni Tecniche
- [ ] Informazioni di gruppo, motore, ecc. sono incluse
- [ ] Tutti i parametri del controllore sono specificati
- [ ] Gli schemi a blocchi sono chiari e completi
- [ ] I confronti simulazione/esperimento sono presenti

### Revisione
- [ ] Il documento è stato riletto da almeno un'altra persona
- [ ] Controllo ortografico completato
- [ ] Tutte le referenze sono corrette
- [ ] Il PDF finale è leggibile e ben formattato

## 15. Template LaTeX Base

```latex
\documentclass[12pt,a4paper]{article}
\usepackage[utf8]{inputenc}
\usepackage[italian]{babel}
\usepackage{amsmath,amsfonts,amssymb}
\usepackage{graphicx}
\usepackage{float}
\usepackage{booktabs}
\usepackage{geometry}
\geometry{margin=2.5cm}

\title{Relazione di Laboratorio \\ 
       Control Engineering Laboratory}
\author{Nome Cognome \\ Gruppo: XX \\ Motore: YYYY}
\date{\today}

\begin{document}
\maketitle

\section{Introduzione}
% Contenuto della Parte 1

\section{Metodologie e Risultati}
% Contenuto della Parte 2

\subsection{Task 1: Identificazione del Sistema}
% ...

\subsection{Task 2: Progetto del Controllore}
% ...

\section{Conclusioni}
% Breve sintesi di cosa hai imparato

\appendix
\section{Codice MATLAB}
% Codici utilizzati

\section{Schemi Simulink Completi}
% Schemi dettagliati

\end{document}
```

---

> **🎯 Ricorda:** L'obiettivo è convincere il professore che hai imparato qualcosa dal corso. Mostra comprensione critica dei risultati, non solo una lista di procedure seguite.

---

**Note:**
- Guida basata sui materiali del Prof. Francesco Ticozzi - Control Engineering Laboratory
- Per ulteriori dettagli, consulta sempre le istruzioni specifiche dell'assignment
- Questa guida può essere utilizzata come riferimento durante tutto il processo di scrittura