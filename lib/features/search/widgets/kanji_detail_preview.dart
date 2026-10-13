import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/data/models/kanji.dart';



class KanjiDetailPreview
    extends StatelessWidget {


  const KanjiDetailPreview({

    super.key,

    required this.kanji,

  });



  final Kanji kanji;



  @override
  Widget build(BuildContext context) {


    return Card(

      child: Padding(

        padding:
        const EdgeInsets.all(20),


        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children: [


            Center(

              child: Text(

                kanji.char,

                style:
                const TextStyle(

                  fontSize: 80,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),

            ),



            Center(

              child: Text(

                kanji.hanViet.join(
                  '・',
                ),

                style:
                const TextStyle(

                  fontSize: 24,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),

            ),



            const Divider(
              height: 32,
            ),



            const Text(
              '📖 Nghĩa',
            ),


            Text(
              kanji.meanings.join(
                ', ',
              ),
            ),



            const SizedBox(
              height: 12,
            ),



            const Text(
              '🔊 Cách đọc',
            ),


            Text(

              [
                ...kanji.onyomi,
                ...kanji.kunyomi,
              ].join(
                ', ',
              ),

            ),



            if (kanji.hint.isNotEmpty) ...[

              const SizedBox(
                height: 12,
              ),


              const Text(
                '💡 Mẹo nhớ',
              ),


              Text(
                kanji.hint,
              ),

            ],



            if (kanji.story.isNotEmpty) ...[

              const SizedBox(
                height: 12,
              ),


              const Text(
                '📚 Liên tưởng',
              ),


              Text(
                kanji.story,
              ),

            ],

          ],

        ),

      ),

    );

  }

}