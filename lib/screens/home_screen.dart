import 'package:flutter/material.dart';
import 'package:flutter_front_end/components/home_table.dart';
import 'package:flutter_front_end/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double maxWidth = screenWidth < 1280 ? screenWidth : 1280;
    var sizeWidthScreen = MediaQuery.of(context).size.width;
    final bool useMobileLayout = sizeWidthScreen < 600;
    final bool useTabletLayout = sizeWidthScreen < 820 && sizeWidthScreen > 600;

    return Scaffold(
      body: Center(
        child: SizedBox(
          height: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: useMobileLayout ? 12 : 20),
                  width: useMobileLayout ? double.infinity : maxWidth,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: useMobileLayout ? 12 : 34,
                            left: useMobileLayout ? 0 : 42,
                            right: useMobileLayout ? 0 : 42),
                        child: Row(
                          mainAxisAlignment: useMobileLayout
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'BUSCA MARVEL',
                                      style: TextStyle(
                                        fontSize: useMobileLayout ? 16 : 27,
                                        fontWeight: FontWeight.w900,
                                        color: kPrimaryColor,
                                        fontFamily: 'Roboto-black',
                                        height: 1.2,
                                      ),
                                    ),
                                    Text(
                                      'TESTE FRONT-END',
                                      style: TextStyle(
                                        fontSize: useMobileLayout ? 16 : 27,
                                        fontWeight: FontWeight.w100,
                                        color: kPrimaryColor,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 54,
                                  height: 4,
                                  color: kPrimaryColor,
                                )
                              ],
                            ),
                            useTabletLayout || useMobileLayout
                                ? Text('')
                                : const Text(
                                    'SAMUEL SANTANA',
                                    style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.w100,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 42, right: 42),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Nome do Personagem',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                Container(
                                  width: 400,
                                  height: 31,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFFA5A5A5), width: 1.0),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: TextField(
                                    style: const TextStyle(fontSize: 12.0),
                                    controller: searchController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: useMobileLayout
                            ? const EdgeInsets.all(0)
                            : const EdgeInsets.only(
                                bottom: 34, left: 42, right: 42),
                        child: TableWidget(
                          searchController: searchController,
                        ),
                      )),
                    ],
                  ),
                ),
              ),
              Container(
                color: kPrimaryColor,
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
