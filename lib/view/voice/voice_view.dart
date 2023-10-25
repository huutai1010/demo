import 'package:etravel_mobile/res/app_color.dart';
import 'package:flutter/material.dart';

class VoiceView extends StatefulWidget {
  const VoiceView({super.key});

  @override
  State<VoiceView> createState() => _VoiceViewState();
}

class _VoiceViewState extends State<VoiceView> {
  double sliderVal = 0.5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: const BackButton(),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.photo_camera_back_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite_border_outlined))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .55,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: List.generate(
                        4,
                        (index) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://cdn3.ivivu.com/2022/10/h%E1%BB%93-con-r%C3%B9a-ivivu-12.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.only(top: 5, right: 15),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://cdn3.ivivu.com/2022/10/h%E1%BB%93-con-r%C3%B9a-ivivu-12.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ))
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              'Ho Con Rua',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text('District 1, HCM City'),
          ),
          Slider(
            inactiveColor: Colors.grey.withOpacity(.4),
            value: sliderVal,
            onChanged: (value) {
              sliderVal = value;
              setState(() {});
            },
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.skip_previous,
                  color: AppColors.primaryColor,
                ),
                iconSize: 50,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.play_circle,
                  color: AppColors.primaryColor,
                ),
                iconSize: 75,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.skip_next,
                  color: AppColors.primaryColor,
                ),
                iconSize: 50,
                onPressed: () {},
              ),
              const Spacer()
            ],
          )
        ],
      ),
    );
  }
}
