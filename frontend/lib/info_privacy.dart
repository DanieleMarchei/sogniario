import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/utils.dart';
import 'package:go_router/go_router.dart';

const String infoText = "Sogniario è un'app creata per registrare e catalogare i tuoi sogni.\n\nPrende nota della qualità del tuo sonno e delle caratteristiche dei tuoi sogni. Inoltre registra vocalmente la descrizione del tuo sogno.\n\nAnalizza la complessità del sogno attraverso tecniche di neurolinguistica e riporta grafi e nuvole di parole per una visualizzazione intuitiva del contenuto del sogno. Permette di tener traccia della qualità del tuo sonno e dei sogni mediante la funzione calendario.\n\nSogniario nasce da una collaborazione tra il Brain and Sleep Research Laboratory dell’Università di Camerino e il Molecular Mind Laboratory della Scuola IMT Alti Studi Lucca. Ha lo scopo di aiutare gli scienziati a comprendere il funzionamento del cervello alla base dell’esperienza cosciente durante il sonno.";

const String privacyText = "Il trattamento delle risposte e dei dati da lei forniti è finalizzato alla realizzazione di una ricerca scientifica relativa all’applicazione delle neuroscienze nella caratterizzazione dei processi decisionali.\n\nI dati raccolti attraverso il questionario sono utilizzati solo a scopo di ricerca e verranno elaborati esclusivamente dal gruppo di ricerca dell’Università di Camerino (UNICAM).\n\nLa partecipazione al questionario è volontaria.\n\nI dati raccolti attraverso il questionario non sono riconducibili in alcun momento alla persona che li ha forniti, da parte del team di ricerca. I report redatti per la presentazione dei risultati della ricerca non potranno contenere in nessun modo informazioni che consentano di identificare coloro che hanno conferito i dati.\n\nSi precisa che le credenziali per usare l'applicazione sono fornite dal personale Unicam e che i dati conferiti non consentono l’identificazione o l’identificabilità del soggetto che risponde al questionario e in tal senso non sono definibili come dati personali ai sensi della normativa di legge.\n\nI risultati della ricerca saranno comunicati in pubblicazioni scientifiche e a conferenze, e resi pubblici solo in forma aggregata e totalmente anonima.\n\nIl trattamento dei dati personali effettuato da UNICAM è improntato ai principi elencati all’art. 5 del Regolamento UE 2016/679.\n\nIl titolare del loro trattamento è l’Università degli Studi di Camerino che ha sede legale in Camerino, Piazza Cavour 19/f – Camerino MC (la sede operativa, a seguito dell’inagibilità post- sisma della sede di Piazza Cavour, è in via D’Accorso 16 – Rettorato – Campus Universitario). I dati di contatto del titolare sono:\nPEC: protocollo@pec.unicam.it\n\nL’Università degli Studi di Camerino ha designato quale Responsabile della Protezione dei Dati Personali il Dott. Stefano Burotti. I suoi recapiti di contatto sono i seguenti:\nE-mail: rpd@unicam.it\nP.E.C.: rpd@pec.unicam.it\n\nL’interessato ha il diritto di esercitare i diritti indicati nella sezione 2, 3 e 4 del Capo III del GDPR,  ove applicabile.\n\nL’interessato ha il diritto di proporre reclamo al Garante per la Protezione dei Dati se ritiene che il trattamento di dati personali che lo riguardi violi il Regolamento EU 2016/2016, ai sensi e nelle modalità dell’art. 77 di detto Regolamento."; /*"Le risposte al questionario saranno raccolte mediante un canale protetto dal protocollo SSL e salvate su un server gestito dall'Università di Camerino.*/

class InfoAndPrivacy extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    bool showMobileLayout = screenWidth < widthConstraint;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Info e Privacy"),
        backgroundColor: Colors.purple.shade100,
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () => context.goNamed(Routes.homeUser.name),
          tooltip: "Torna alla pagina iniziale",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: min(screenWidth, halfWidthConstraint)),
            child: ListView(
              children: [
                SizedBox(height: screenHeight * 0.025,),
                const Center(
                  child: SelectableText("Informazioni", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SelectableText(infoText, textAlign: TextAlign.justify),
                SizedBox(height: screenHeight * 0.025,),
                const Center(
                  child: SelectableText("Privacy", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SelectableText(privacyText, textAlign: TextAlign.justify),
                SizedBox(height: screenHeight * 0.025,),
              ],
            ),
          ),
        ),
      )
    );
  }
}
