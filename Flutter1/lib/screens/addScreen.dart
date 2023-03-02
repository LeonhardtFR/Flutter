import 'package:flutter/material.dart';

class addScreen extends StatefulWidget {
  const addScreen({Key? key}) : super(key: key);

  @override
  State<addScreen> createState() => _addScreenState();
}

class _addScreenState extends State<addScreen> {

  // Obligatoire pour le "Validator"
  final _formKey = GlobalKey<FormState>();

  // Recevoir les données saisies
  final TitleController = TextEditingController();
  final DescriptionController = TextEditingController();

  // Libérer les ressources mémoires
  @override
  void dispose() {
    super.dispose();
    TitleController.dispose();
    DescriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Form(
          key: _formKey,
          child: Column(
            children: [

              // Titre de la liste
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Titre de la liste',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir un titre';
                    }
                    return null;
                  },
                  controller: TitleController,
                ),
              ),

              // Description de la liste
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description de la liste',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir une description';
                    }
                    return null;
                  },
                  controller: DescriptionController,
                ),
              ),

              SizedBox(
                width: 250,
                child: ElevatedButton(
                    onPressed: (){
                      if (_formKey.currentState!.validate()) {
                        // On récupère les données saisies
                        final title = TitleController.text;
                        final description = DescriptionController.text;

                        print("Titre: $title");
                        print("Description: $description");

                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('Traitement en cours...')));

                        // Mise à jour des champs Text()
                        setState(() {
                          TitleController.text = title;
                          DescriptionController.text = description;
                        });

                      }

                      // Pour fermer le clavier automatiquement quand on appui sur le bouton
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: const Text('Confirmer'),
                ),
              ),


              Text("Titre: ${TitleController.text}"),
              Text("Description: ${DescriptionController.text}"),

            ],
          )
      ),
    );
  }
}
