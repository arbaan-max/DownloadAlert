import 'package:download_tow/core/exports.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final Dio dio ;
  ProductBloc({required this.dio}) : super(ProductInitial()) {
    on<FetchProduct>(_onFetchProduct);
  }

  FutureOr<void> _onFetchProduct(FetchProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final response = await dio.get('https://fakestoreapi.com/products');
      if (response.statusCode == 200) {
        final List<ProductModel> products = (response.data as List).map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
        emit(ProductLoaded(products));
      } else {
        emit(const ProductError("Failed to load products"));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  /// Download the image from the given URL
  // Future<void> downloadImage(String url, Function(double) onProgress, imageID) async {
  //   bool permissionGranted = true;

  //   // Request necessary permissions
  //   if (await Permission.manageExternalStorage.isGranted) {
  //     permissionGranted = true;
  //   } else if (await Permission.manageExternalStorage.request().isGranted) {
  //     permissionGranted = true;
  //   }

  //   if (permissionGranted) {
  //     try {
  //       // Get the public Pictures directory
  //       Directory? directory = Directory('/storage/emulated/0/Pictures/download_tow');
  //       if (!(await directory.exists())) {
  //         directory = await directory.create(recursive: true); // Create directory if not exists
  //       }

  //       String savePath = '${directory.path}/$imageID.jpg';
  //       print('\x1B[32m savePath: $savePath \x1B[0m');

  //       // Download the image
  //       await Dio().download(
  //         url,
  //         savePath,
  //         onReceiveProgress: (rec, total) {
  //           onProgress((rec / total) * 100);
  //         },
  //       );

  //       // Notify gallery about the new image
  //       // await _addImageToGallery(savePath);

  //       print("Download completed and saved to gallery.");
  //     } catch (e) {
  //       print('\x1B[31m Error: $e \x1B[0m');
  //     }
  //   } else {
  //     throw Exception("Permission denied");
  //   }
  // }
}
