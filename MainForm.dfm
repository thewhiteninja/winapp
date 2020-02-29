object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'WinApp Store'
  ClientHeight = 548
  ClientWidth = 741
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Calibri'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ScreenSnap = True
  OnCanResize = FormCanResize
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel5: TPanel
    Left = 185
    Top = 0
    Width = 556
    Height = 399
    Align = alClient
    BevelOuter = bvLowered
    BorderWidth = 1
    Caption = 'No application list found, try update it.'
    TabOrder = 3
    Visible = False
    ExplicitTop = 70
    ExplicitHeight = 377
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 527
    Width = 741
    Height = 21
    Panels = <
      item
        Width = 520
      end
      item
        Text = 'Last list modification : 28/02/2007 61:12'
        Width = 60
      end>
    ParentFont = True
    UseSystemFont = False
    ExplicitTop = 575
  end
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 402
    Width = 735
    Height = 122
    Align = alBottom
    Caption = 'Logs'
    TabOrder = 0
    ExplicitLeft = -2
    ExplicitTop = 450
    object RichEdit1: TRichEdit
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 725
      Height = 99
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Calibri'
      Font.Style = []
      HideScrollBars = False
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      Zoom = 100
      OnChange = RichEdit1Change
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 399
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 70
    ExplicitHeight = 377
    object CheckListBox1: TCheckListBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 179
      Height = 258
      Align = alClient
      ItemHeight = 15
      Style = lbOwnerDrawVariable
      TabOrder = 0
      OnClick = CheckListBox1Click
      ExplicitTop = 37
      ExplicitHeight = 221
    end
    object Panel4: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 267
      Width = 179
      Height = 129
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitTop = 315
      object Label20: TLabel
        Left = 0
        Top = 69
        Width = 179
        Height = 18
        Cursor = crHandPoint
        Align = alBottom
        Alignment = taCenter
        AutoSize = False
        Caption = 'Start installation '
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Calibri'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = False
        Layout = tlCenter
        OnClick = Label20Click
        OnMouseEnter = Label20MouseEnter
        OnMouseLeave = Label20MouseLeave
        ExplicitTop = 78
      end
      object Label21: TLabel
        Left = 9
        Top = 2
        Width = 50
        Height = 18
        AutoSize = False
        Caption = 'Selection : '
        Layout = tlCenter
      end
      object Label22: TLabel
        Left = 100
        Top = 2
        Width = 28
        Height = 18
        Cursor = crHandPoint
        AutoSize = False
        Caption = 'invert'
        Color = clBtnFace
        ParentColor = False
        Transparent = False
        Layout = tlCenter
        OnClick = Label22Click
        OnMouseEnter = Label20MouseEnter
        OnMouseLeave = Label20MouseLeave
      end
      object Label23: TLabel
        Left = 134
        Top = 2
        Width = 36
        Height = 18
        Cursor = crHandPoint
        AutoSize = False
        Caption = 'nothing'
        Color = clBtnFace
        ParentColor = False
        Transparent = False
        Layout = tlCenter
        OnClick = Label23Click
        OnMouseEnter = Label20MouseEnter
        OnMouseLeave = Label20MouseLeave
      end
      object Label24: TLabel
        Left = 82
        Top = 2
        Width = 12
        Height = 18
        Cursor = crHandPoint
        AutoSize = False
        Caption = 'all'
        Color = clBtnFace
        ParentColor = False
        Transparent = False
        Layout = tlCenter
        OnClick = Label24Click
        OnMouseEnter = Label20MouseEnter
        OnMouseLeave = Label20MouseLeave
      end
      object Label26: TLabel
        Left = 0
        Top = 33
        Width = 179
        Height = 18
        Cursor = crHandPoint
        Align = alBottom
        Alignment = taCenter
        AutoSize = False
        Caption = 'Download files'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Calibri'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        Layout = tlCenter
        OnClick = Label26Click
        OnMouseEnter = Label20MouseEnter
        OnMouseLeave = Label20MouseLeave
        ExplicitLeft = -3
        ExplicitTop = 26
      end
      object Label27: TLabel
        Left = 0
        Top = 51
        Width = 179
        Height = 18
        Cursor = crHandPoint
        Align = alBottom
        Alignment = taCenter
        AutoSize = False
        Caption = 'Create ISO image'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Calibri'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        Layout = tlCenter
        OnClick = Label27Click
        OnMouseEnter = Label20MouseEnter
        OnMouseLeave = Label20MouseLeave
        ExplicitTop = 73
      end
      object Label5: TLabel
        Left = 0
        Top = 114
        Width = 179
        Height = 15
        Cursor = crHandPoint
        Align = alBottom
        Alignment = taCenter
        AutoSize = False
        Caption = 'About'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Calibri'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = False
        Layout = tlCenter
        OnClick = Label5Click
        OnMouseEnter = Label20MouseEnter
        OnMouseLeave = Label20MouseLeave
      end
      object Label4: TLabel
        Left = 0
        Top = 96
        Width = 179
        Height = 18
        Cursor = crHandPoint
        Align = alBottom
        Alignment = taCenter
        AutoSize = False
        Caption = 'Update applications list'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Calibri'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = False
        Layout = tlCenter
        OnClick = Label4Click
        OnMouseEnter = Label20MouseEnter
        OnMouseLeave = Label20MouseLeave
        ExplicitTop = 99
      end
      object Label29: TLabel
        Left = 0
        Top = 87
        Width = 179
        Height = 9
        Align = alBottom
        Alignment = taCenter
        Color = clBtnFace
        ParentColor = False
        Transparent = False
        ExplicitTop = 90
      end
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 188
    Top = 3
    Width = 550
    Height = 393
    Align = alClient
    BevelKind = bkFlat
    BevelOuter = bvNone
    Color = clWhite
    FullRepaint = False
    ParentBackground = False
    TabOrder = 4
    ExplicitTop = 73
    ExplicitHeight = 371
    object Label2: TLabel
      Left = 0
      Top = 0
      Width = 546
      Height = 18
      Align = alTop
      AutoSize = False
      Caption = 'Description :'
      Color = clBtnFace
      ParentColor = False
      Transparent = False
      Layout = tlCenter
      ExplicitLeft = 3
      ExplicitTop = 3
      ExplicitWidth = 537
    end
    object Label3: TLabel
      Left = 0
      Top = 371
      Width = 546
      Height = 18
      Align = alBottom
      AutoSize = False
      Caption = 'Etat :'
      Color = clBtnFace
      ParentColor = False
      Transparent = False
      Layout = tlCenter
      ExplicitTop = 349
      ExplicitWidth = 543
    end
    object Image1: TImage
      Left = 11
      Top = 32
      Width = 150
      Height = 150
      Center = True
      IncrementalDisplay = True
      Proportional = True
      Transparent = True
    end
    object Label6: TLabel
      Left = 184
      Top = 32
      Width = 35
      Height = 13
      Caption = 'Name : '
    end
    object Label7: TLabel
      Left = 184
      Top = 89
      Width = 47
      Height = 13
      Caption = 'Website : '
    end
    object Label8: TLabel
      Left = 184
      Top = 144
      Width = 48
      Height = 13
      Caption = 'Main file : '
    end
    object Label9: TLabel
      Left = 184
      Top = 51
      Width = 42
      Height = 13
      Caption = 'Version : '
    end
    object Label10: TLabel
      Left = 184
      Top = 70
      Width = 39
      Height = 13
      Caption = 'Author : '
    end
    object Label11: TLabel
      Left = 184
      Top = 125
      Width = 25
      Height = 13
      Caption = 'Size : '
    end
    object Label12: TLabel
      Left = 184
      Top = 163
      Width = 48
      Height = 13
      Caption = 'Platform : '
    end
    object Label13: TLabel
      Left = 265
      Top = 32
      Width = 2
      Height = 13
    end
    object Label14: TLabel
      Left = 265
      Top = 51
      Width = 2
      Height = 13
    end
    object Label15: TLabel
      Left = 265
      Top = 70
      Width = 2
      Height = 13
    end
    object Label16: TLabel
      Left = 265
      Top = 89
      Width = 22
      Height = 13
      Cursor = crHandPoint
      Caption = 'here'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'Calibri'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = Label16Click
    end
    object Label17: TLabel
      Left = 265
      Top = 125
      Width = 2
      Height = 13
    end
    object Label18: TLabel
      Left = 265
      Top = 144
      Width = 22
      Height = 13
      Cursor = crHandPoint
      Caption = 'here'
      Color = clBlue
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'Calibri'
      Font.Style = [fsUnderline]
      ParentColor = False
      ParentFont = False
      OnClick = Label18Click
    end
    object Label19: TLabel
      Left = 265
      Top = 163
      Width = 2
      Height = 13
    end
    object Label25: TLabel
      Left = 293
      Top = 144
      Width = 2
      Height = 13
    end
    object RichEdit2: TRichEdit
      AlignWithMargins = True
      Left = 3
      Top = 196
      Width = 540
      Height = 172
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Calibri'
      Font.Style = []
      HideScrollBars = False
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      Zoom = 100
      ExplicitHeight = 150
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.iso'
    Filter = 'Fichier ISO|*.iso|Tous les fichiers|*.*'
    FilterIndex = 0
    InitialDir = 'C:\'
    Options = [ofHideReadOnly, ofShowHelp, ofCreatePrompt, ofEnableSizing]
    Left = 600
    Top = 504
  end
end
