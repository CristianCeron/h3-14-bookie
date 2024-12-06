import 'package:flutter/material.dart';
import 'package:h3_14_bookie/config/theme/app_colors.dart';
import 'package:h3_14_bookie/presentation/widgets/widgets.dart';

class BookReadScreen extends StatelessWidget {
  static const name = 'book-read-screen';
  const BookReadScreen({super.key});
  @override

  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final keyScaffold = GlobalKey<ScaffoldState>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: keyScaffold,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
                      keyScaffold.currentState!.openEndDrawer();
          }, icon: const Icon(Icons.list))
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppColors.primaryColor,
            height: 1.0,
          )
        ),
        shadowColor: AppColors.primaryColor,
        surfaceTintColor: Colors.transparent,
      ),
      endDrawer: const SelectChapterDrawer(),
      body: BorderLayout(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Capítulo 1: El Vestíbulo de los Susurros', style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
                Container(
                  width: size.width * 0.9,
                  height: size.width * 0.5,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(15)
                  ),
                ),
                const SizedBox(height: 10,),
                const IconLabelWidget(label: 'Próxima ubicación a 2km', icon: Icons.place_outlined, center: true,),
                const Text(
                  'La noche era más oscura de lo habitual cuando Valeria cruzó la verja de hierro que rodeaba la famosa Mansión de los Susurros. El viento helado parecía cargar una advertencia, pero ella lo ignoró, decidida a desentrañar los secretos de aquel lugar. La puerta principal, decorada con figuras grotescas, pasó con un chirrido que resonó en el vacío. El vestíbulo era imponente, con un gran candelabro cubierto de telarañas suspendido en el techo. Valeria avanzó despacio, su linterna iluminando las paredes adornadas con retratos antiguos cuyos ojos parecían seguirla. La atmósfera era densa, como si algo invisible la rodeara. Mientras grababa sus observaciones, el espejo del vestíbulo captó su atención. Era un objeto enorme, con un marco de madera tallada en formas retorcidas. Cuando se dirige la linterna hacia él, vio una figura oscura detrás de su reflejo. Se giró rápidamente, pero no había nadie.',
                  textAlign: TextAlign.justify,
                ),
                const BookNavigation()
            ],
          ),
        ),
      ),
    );
  }
}