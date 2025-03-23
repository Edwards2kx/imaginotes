// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:imaginotes/di.dart';
// import 'package:imaginotes/features/notes/ui/tags_bloc/tags_bloc.dart';

// class MyWidget extends StatelessWidget {
//   const MyWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//    return DraggableScrollableSheet(
//         initialChildSize: 0.4, // Tamaño inicial
//         minChildSize: 0.3, // Tamaño mínimo
//         maxChildSize: 0.8, // Tamaño máximo
//         expand: false,
//         builder: (context, scrollController) {
//           return Container(
//             decoration: BoxDecoration(
//               color: Theme.of(context).scaffoldBackgroundColor,
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//             ),
//             child: BlocBuilder<TagsBloc, TagsState>(
//               bloc: getIt<TagsBloc>(),
//               builder: (context, state) {
//                 if (state is TagsLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (state is TagsLoaded) {
//                   return Column(
//                     children: [
//                       // Barra superior con título y botón de nueva etiqueta
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Guardar en...',
//                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return AlertDialog(
//                                       title: const Text('Nueva etiqueta'),
//                                       content: TextField(
//                                         // onChanged: (value) => newTagName = value,
//                                         decoration: const InputDecoration(hintText: 'Nombre de la etiqueta'),
//                                       ),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () => Navigator.of(context).pop(),
//                                           child: const Text('Cancelar'),
//                                         ),
//                                         TextButton(
//                                           onPressed: () {
//                                             // if (newTagName.isNotEmpty) {
//                                             //   context.read<TagsBloc>().add(SaveTag(tagValue: newTagName));
//                                             //   Navigator.of(context).pop();
//                                             // }
//                                           },
//                                           child: const Text('Agregar'),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 );
//                               },
//                               child: const Text('+ Nueva etiqueta'),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Lista de etiquetas con checkboxes
//                       if (state.tags.isEmpty)
//                         const Padding(
//                           padding: EdgeInsets.all(16.0),
//                           child: Text('No hay etiquetas disponibles'),
//                         )
//                       else
//                         Expanded(
//                           child: ListView.builder(
//                             controller: scrollController, // Permite deslizar
//                             itemCount: state.tags.length,
//                             itemBuilder: (context, index) {
//                               final tag = state.tags[index];
//                               return CheckboxListTile(
//                                 title: Text(tag.value),
//                                 value: selectedTags.contains(tag.value),
//                                 onChanged: (isChecked) {
//                                   if (isChecked == true) {
//                                     selectedTags.add(tag.value);
//                                   } else {
//                                     selectedTags.remove(tag.value);
//                                   }
//                                 },
//                               );
//                             },
//                           ),
//                         ),

//                       // Botón de confirmación
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             minimumSize: const Size(double.infinity, 48),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                           ),
//                           onPressed: () {
//                             // Aquí puedes manejar la selección de etiquetas
//                             Navigator.of(context).pop();
//                           },
//                           child: const Text('Listo'),
//                         ),
//                       ),
//                     ],
//                   );
//                 } else {
//                   return const SizedBox.shrink();
//                 }
//               },
//             ),
//           );
//         },
//       );
//     },
//   );
//   }
// }

