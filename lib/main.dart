import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:country_code_picker/country_code_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shortener',
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: _size.width,
            height: _size.height,
            child: Image.asset(
              "assets/image/blockchain.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SizedBox(
              width: _size.width * 0.9,
              height: _size.width * 0.9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 05, sigmaY: 5),
                      child: const GlassMorphism()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GlassMorphism extends StatefulWidget {
  // final double blur;final double opacity;final Widget child ;

  // const GlassMorphism({super.key,required this.blur,required this.opacity,required this.child});
  const GlassMorphism({super.key});
  @override
  State<GlassMorphism> createState() => _GlassMorphismState();
}

class _GlassMorphismState extends State<GlassMorphism> {
  final _formkey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  String _code = "+237";
  @override
  void dispose() {
    _controller.dispose;
    super.dispose();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 18, left: 18, bottom: 15),
          child: Text(
            "Enter Contact",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 35),
          ),
        ),
        SizedBox(
          height: _size.height * 0.07,
        ),
        Center(
          child: Form(
            key: _formkey,
            child: SizedBox(
              width: _size.width * 0.8,
              height: _size.height * 0.09,
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: _controller,
                decoration: InputDecoration(
                    prefixIcon: CountryCodePicker(
                      onChanged: (value) {
                        setState(() {
                          _code = value.toString();
                        });
                      },
                      dialogSize: const Size(500, 450),
                      hideMainText: true,
                      showFlagMain: true,
                      showFlag: true,
                      initialSelection: 'CM',
                      showOnlyCountryWhenClosed: true,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "no phone number entered";
                  }
                },
              ),
            ),
          ),
        ),
        SizedBox(
          height: _size.height * 0.01,
        ),
        Center(
          child: ElevatedButton(
            style: ButtonStyle(
              fixedSize: WidgetStateProperty.all(Size(_size.width * 0.8, 60)),
              backgroundColor: WidgetStateProperty.all(Colors.black45),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: isLoading ? null : validator,
            child: isLoading
                ? const CircularProgressIndicator.adaptive()
                : Text(
                    "launch",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
          ),
        )
      ],
    );
  }

  void validator() {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = !isLoading;
      });

      _launchUrl("https://wa.me/${_code + _controller.value.text}");
    }
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      setState(() {
        isLoading = !isLoading;
      });

      throw Exception('Could not launch $_url');
    }
  }
}
