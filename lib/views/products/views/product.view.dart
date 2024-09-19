import 'dart:developer';

import 'package:download_tow/core/exports.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    LocalNotificationService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Adjust the number of columns
                  crossAxisSpacing: 16.0, // Spacing between columns
                  mainAxisSpacing: 16.0, // Spacing between rows
                  childAspectRatio: 0.5, // Adjust for taller product cards
                ),
                itemCount: state.product.length,
                itemBuilder: (BuildContext context, int index) {
                  final data = state.product[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 3.0),
                          blurRadius: 3.0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: Image.network(
                              data.image ?? '',
                              width: double.infinity,
                              fit: BoxFit.fitHeight,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        // Product Details
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Title : ${data.title ?? ""}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text("₹ : ${data.price ?? ""}"),
                              Text(
                                "Desc : ${data.description ?? ""}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              OutlinedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(Colors.grey[300]),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                icon: Image.asset(
                                  "assets/download.png",
                                  width: 15,
                                  height: 15,
                                ),
                                onPressed: () async {
                                  BlocProvider.of<DownloadBloc>(context).add(DownloadProduct(
                                    url: data.image ?? '',
                                    imageID: data.id.toString(),
                                    onProgress: (progress) {
                                      log(progress.toString());
                                    },
                                  ));
                                },
                                label: const Text("Image"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is ProductError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text("No Data"));
          },
        ),
      ),
    );
  }
}
