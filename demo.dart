RxList<Count1> Countlist = RxList<Count1>([]);
updateTrans(String paymentId, String OrderId, String Signature) async {
  Dio dio = Dio();
  Options option = Options(headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${box.read(ArgumentConstant.token)}',
  });
  try {
    final response = await dio.put(
      baseUrl + ApiConstant.transcation + "/${checkout.data!.transaction!.sId}",
      data: {
        "paymentDetails": {"paymentId": "${paymentId}", "orderId": "${OrderId}", "signature": "${Signature}"}
      },
      options: option,
    );
    print("UPDATE=========" + response.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.data);
    } else if (response.statusCode == 400) {
    } else {}
  } on SocketException {}
}

Future<void> updateAddressApi() async {
  var url = Uri.parse(baseUrl3 + ApiConstant.addressUpdate);
  await http.put(url, body: {
    'address': shopController.value.text + " " + buildingNameController.value.text + " " + _currentAddress,
    'latitude': _currentPosition!.value.latitude.toString(),
    'longitude': _currentPosition!.value.longitude.toString(),
  }, headers: {
    'Authorization': 'Bearer ${box.read(ArgumentConstant.token)}',
    // 'Content-Type': 'application/json'
  }).then((value) {
    shopController.value.clear();
    buildingNameController.value.clear();
    if (value.statusCode == 200) {
      UpdateAddressModel res = UpdateAddressModel.fromJson(jsonDecode(value.body));
      box.write(ArgumentConstant.address, res.data!.address ?? "");
      newLocation.value = res.data!.address ?? "";
      isLocationChanged.value = true;
    }
    print('Response status: ${value.statusCode}');
    print('Response body: ${value.body}');
  }).catchError((error) {
    print(error);
  });
}
