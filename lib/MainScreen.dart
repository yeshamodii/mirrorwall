import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  InAppWebViewController controller=InAppWebViewController(1, InAppWebView());
  late PullToRefreshController pullToRefreshController;
  int _currentIndex = 0;
  String url='https://www.google.com/';
  @override
  void initState(){
    pullToRefreshController=PullToRefreshController(
      onRefresh:(){
        controller.reload();
      }
    );
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My Browser'
        ),
        actions: [
          PopupMenuButton(itemBuilder: (context){
            return[
              PopupMenuItem(value:1,
                  child: TextButton.icon(onPressed: (){}, icon: Icon(Icons.bookmark), label: Text('All BookMark')
              )),
              PopupMenuItem(value:2,
                  child: TextButton.icon(onPressed: (){}, icon: Icon(Icons.screen_search_desktop), label: Text('Search engine')
                  ))
            ];
          })
        ],
      ),
      body: InAppWebView(
        pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (controller) {
            this.controller = controller;
          },
        initialUrlRequest: URLRequest(url: Uri.parse('https://www.google.com/')),
        onProgressChanged: (controller,progress){
          if (progress==100){
            pullToRefreshController?.endRefreshing();
            }
          }
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Set the type to fixed
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
      icon: Icon(Icons.home,size: 25), onPressed: () {  },
            ),label: ''),
    BottomNavigationBarItem(icon: IconButton(icon: Icon(Icons.bookmark_add_outlined,size: 25,), onPressed: () {  },),label: ''),
          BottomNavigationBarItem(
            icon:   IconButton(
    onPressed: ()async{
    if((
    await controller?.canGoBack()
    )??false
    )
    await controller.goBack();
    },
    icon: Icon(Icons.keyboard_arrow_left_outlined,size: 25),
    ),label: ''
          ),
          BottomNavigationBarItem(
              icon: IconButton(
                onPressed: (){
                  controller.reload();},
                icon: Icon(Icons.refresh,size: 25),
              ),label: ''
          ),
          BottomNavigationBarItem(
              icon: IconButton(
                onPressed: ()async{
                  if((
                      await controller?.canGoForward()
                  )??false
                  )
                    await controller.goForward();
                },
                icon: Icon(Icons.keyboard_arrow_right_outlined,size: 25),
              ),label: ''
          ),

        ],
      ),
    );
  }
  void addFavouriteLink(BuildContext context)async{
    final String? newLink=await showDialog(context: context, builder: (BuildContext context){
      return SimpleDialog(
        title: Text('Add Favourite Link'),
        children: <Widget>[
          TextField(
            onSubmitted: (link)
      {
        Navigator.pop(context,link);
      }
      ),
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Save'))
        ],
      );
    }
    );
  }
}
