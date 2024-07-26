import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayPage extends StatefulWidget {
  const RazorPayPage({super.key});

  @override
  State<RazorPayPage> createState() => _RazorPayPageState();
}

class _RazorPayPageState extends State<RazorPayPage> {

  late Razorpay _razorpay;
  TextEditingController amtController = TextEditingController();

  void openCheckout(amount) async{
    amount = amount*100;
    var options = {
      'key': 'rzp_test_1DP5nmlF5G5ag',
      'amount': amount,
      'name': '',
      'prefill': { 'contact' : '1234567890', 'email' : 'test@gmail.com'},
      'external': {
        'wallets': ['paym']
      }
    };
    try{
      _razorpay.open(options);
    }catch(e){
      debugPrint('Error: e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response){
    Fluttertoast.showToast(msg: "Ödeme Başarılı"+response.paymentId!, toastLength: Toast.LENGTH_SHORT);
  }

  void handlePaymentError(PaymentFailureResponse response){
    Fluttertoast.showToast(msg: "Ödeme Başarısız"+response.message!, toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWallet(ExternalWalletResponse response){
    Fluttertoast.showToast(msg: "External Wallet"+response.walletName!, toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose(){
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey[800],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100,),
            Image.network('https://viegoglobal.com/wp-content/uploads/2020/11/Qaiware-payment-magic-thegem-blog-default-1024x473.jpg',
              height: 100 , width: 300,),
            SizedBox(height: 50
              ,),
            Text('Razorpay Ödeme Sağlayıcısı  Entegrasyonuna Hoşgeldiniz', style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,),
            SizedBox(height: 30,),
            Padding(padding: EdgeInsets.all(8),
            child: TextFormField(
              cursorColor: Colors.white,
              autofocus: false,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Ödenecek Tutarı Girin',
                labelStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
                errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
              ),
              controller: amtController,
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Lütfen ödenecek tutarı girin!';
                }
                return null;
              },
            ),),
            SizedBox(height: 30,),
            ElevatedButton(onPressed: (){
              if(amtController.text.toString().isNotEmpty){
                setState(() {
                  int amount = int.parse(amtController.text.toString());
                  openCheckout(amount);
                });
              }
            }, child: Padding(
              padding: EdgeInsets.all(8),
              child: Text('Ödeme Yap', style: TextStyle(color: Colors.white),),
            ),
              style: ElevatedButton.styleFrom(backgroundColor:Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}


















