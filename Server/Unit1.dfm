object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Desktop Streaming Server'
  ClientHeight = 375
  ClientWidth = 558
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    558
    375)
  PixelsPerInch = 96
  TextHeight = 15
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 559
    Height = 322
    Anchors = [akLeft, akTop, akRight, akBottom]
    Stretch = True
    ExplicitWidth = 625
    ExplicitHeight = 412
  end
  object Label1: TLabel
    Left = 324
    Top = 331
    Width = 83
    Height = 15
    Anchors = [akRight, akBottom]
    Caption = 'Select Monitor: '
    ExplicitLeft = 390
    ExplicitTop = 421
  end
  object ComboBox1: TComboBox
    Left = 413
    Top = 327
    Width = 145
    Height = 23
    Anchors = [akRight, akBottom]
    TabOrder = 0
    OnChange = ComboBox1Change
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 356
    Width = 558
    Height = 19
    Panels = <
      item
        Text = 'Total Monitors: 0'
        Width = 150
      end>
  end
  object Button1: TButton
    Left = 0
    Top = 325
    Width = 318
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Start Desktop Capture'
    Enabled = False
    TabOrder = 2
    OnClick = Button1Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 40
    Top = 64
  end
  object ServerSocket1: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    Left = 40
    Top = 16
  end
end
