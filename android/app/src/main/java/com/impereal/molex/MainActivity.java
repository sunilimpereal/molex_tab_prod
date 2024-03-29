package com.impereal.molex;

import androidx.annotation.NonNull;

import com.example.tscdll.TscWifiActivity;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.impereal.dev/tsc";
    TscWifiActivity TscEthernetDll = new TscWifiActivity();
    private String PrintLabel(String ip,String bundleQty,String routeno,String date, String orderId,String qr, String fgpart,String cutLength,
                        String cablePart,String wireGauge,String terminalFrom,String terminalto,String userid,String shift,String machine ){
        String status="success";
        String op = TscEthernetDll.openport(ip, 9100);
        System.out.println("ip: "+ip);
        System.out.println("bundle Qty:"+bundleQty);
        System.out.println("Route No:"+routeno);
        System.out.println("date"+date);
        System.out.println("Qr:"+qr);
        System.out.println("fgpart"+fgpart);
        System.out.println("Order Id"+orderId);
        System.out.println("cutlength"+cutLength);
        System.out.println("cablePart"+cablePart);
        System.out.println("wiregauge :"+wireGauge);
        System.out.println("terminal from :"+terminalFrom);
        System.out.println("terminal to:"+terminalto);
        System.out.println("bundleId"+qr);
        System.out.println("useriD"+userid);
        System.out.println("shift:"+shift);
        System.out.println("machine ID:"+machine);
        if (op == "1") {
            TscEthernetDll.downloadpcx("UL.PCX");
            TscEthernetDll.downloadbmp("Triangle.bmp");
            TscEthernetDll.setup(101, 50 , 4, 4, 0, 3, 0);
            TscEthernetDll.clearbuffer();
            TscEthernetDll.sendcommand("SET TEAR ON\n");
            TscEthernetDll.sendcommand("CLS\n");
            TscEthernetDll.sendcommand("BITMAP 403,1,1,400,1,ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\n");
            TscEthernetDll.sendcommand("QRCODE 772,282,L,8,A,180,M2,S7,\""+qr+"\"\n");
            TscEthernetDll.sendcommand("CODEPAGE 1252\n");
            TscEthernetDll.sendcommand("TEXT 514,13,\"0\",90,7,7,\"ROUTE NO\"\n");
            TscEthernetDll.sendcommand("TEXT 487,13,\"0\",90,8,8,\""+routeno+"\"\n");
            // TscEthernetDll.sendcommand("TEXT 773,40,\"0\",180,9,9,\"\"\n");
            TscEthernetDll.sendcommand("TEXT 315,384,\"0\",180,9,9,\"FG PART NO:\"\n");
            TscEthernetDll.sendcommand("TEXT 315,69,\"0\",180,9,9,\"TERMINAL P/N \\[\"]TO\\[\"]:\"\n");
            TscEthernetDll.sendcommand("TEXT 315,325,\"0\",180,9,9,\"ORDER ID:\"\n");
            TscEthernetDll.sendcommand("TEXT 315,292,\"0\",180,9,9,\"CUT LENGTH:\"\n");
            TscEthernetDll.sendcommand("TEXT 315,195,\"0\",180,9,9,\"WIRE GAUGE:\"\n");
            TscEthernetDll.sendcommand("TEXT 316,131,\"0\",180,9,9,\"TERMINAL P/N \\[\"] FROM\\[\"]:\"\n");
            TscEthernetDll.sendcommand("TEXT 315,259,\"0\",180,9,9,\"CABLE PART#:\"\n");
            TscEthernetDll.sendcommand("TEXT 315,356,\"0\",180,9,9,\""+fgpart+"\"\n");
            TscEthernetDll.sendcommand("TEXT 315,37,\"0\",180,9,9,\""+terminalto+"\"\n");
            TscEthernetDll.sendcommand("TEXT 205,325,\"0\",180,9,9,\""+orderId+"\"\n");
            TscEthernetDll.sendcommand("TEXT 173,292,\"0\",180,9,9,\""+cutLength+"\"\n");
            TscEthernetDll.sendcommand("TEXT 315,168,\"0\",180,9,9,\""+wireGauge+"\"\n");
            TscEthernetDll.sendcommand("TEXT 315,103,\"0\",180,9,9,\""+terminalFrom+"\"\n");
            TscEthernetDll.sendcommand("TEXT 315,231,\"0\",180,9,9,\""+cablePart+"\"\n");
            TscEthernetDll.sendcommand("TEXT 773,67,\"0\",180,8,8,\"BUNDLE QTY:\"\n");
            TscEthernetDll.sendcommand("TEXT 633,67,\"0\",180,8,8,\""+bundleQty+"\"\n");
            // TscEthernetDll.sendcommand("TEXT 773,34,\"0\",180,8,8,\"DATE:\"\n");
            TscEthernetDll.sendcommand("TEXT 773,34,\"0\",180,8,8,\""+date+"\"\n");
            TscEthernetDll.sendcommand("TEXT 774,379,\"0\",180,8,8,\""+"BUNDLE ID:"+"\"\n");
            TscEthernetDll.sendcommand("TEXT 773,315,\"0\",180,8,8,\""+"MC ID:"+"\"\n");
            TscEthernetDll.sendcommand("TEXT 644,34,\"0\",180,8,8,\""+"SHIFT:"+"\"\n");
            TscEthernetDll.sendcommand("TEXT 579,34,\"0\",180,8,8,\""+shift+"\"\n");
            TscEthernetDll.sendcommand("TEXT 683,345,\"0\",180,8,8,\""+userid+"\"\n");
            TscEthernetDll.sendcommand("TEXT 653,379,\"0\",180,8,8,\""+qr+"\"\n");
            TscEthernetDll.sendcommand("TEXT 773,345,\"0\",180,8,8,\""+"USER ID:"+"\"\n");
            TscEthernetDll.sendcommand("TEXT 706,315,\"0\",180,8,8,\""+machine+"\"\n");
            TscEthernetDll.sendcommand("PRINT 1,1\"\n");
            TscEthernetDll.sendcommand("PUTBMP 100,520,\"Triangle.bmp\"\n");
            // status = TscEthernetDll.printerstatus();
            TscEthernetDll.printlabel(1, 1);
            //TscEthernetDll.sendfile("zpl.txt");
            TscEthernetDll.closeport(5000);

        }else{
            status ="-1";
        }
        return status;


    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if(call.method.equals("Print")){
                                String ip = call.argument("ipaddress");
                                String qr = call.argument("qr");
                                String bundleqty = call.argument("bundleQty");
                                String date = call.argument("date");
                                String orderId = call.argument("orderId");
                                String routenumber = call.argument("routenumber1");
                                String fgpartnumber =call.argument("fgPartNumber");
                                String cutlength =call.argument("cutlength");
                                String cablepart =call.argument("cutpart");
                                String wireGauge =call.argument("wireGauge");
                                String terminalfrom =call.argument("terminalfrom");
                                String terminalto =call.argument("terminalto");
                                String userid =call.argument("userid");
                                String shift =call.argument("shift");
                                String machine =call.argument("machine");
                                
                                String status = PrintLabel(ip,bundleqty,routenumber,date,orderId,qr,fgpartnumber,cutlength,cablepart,wireGauge,terminalfrom,terminalto,userid,shift,machine);
                                if(status != "-1") {
                                    result.success(status);
                                }else{
                                    result.error("-1 not printed","Printer not available",false);
                                }
                            }else{
                                result.notImplemented();
                            }
                        }
                );
    }
}
