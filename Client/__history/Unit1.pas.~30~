unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls,
  pngimage, System.Win.ScktComp, System.NetEncoding;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    ConnectionTimer: TTimer;
    ClientSocket1: TClientSocket;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ConnectionTimerTimer(Sender: TObject);
    procedure ClientSocket1Connect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
  private
    procedure HandleCommand(const aData: string);
    procedure SaveReceivedImageToTemp(aBitmap: TBitmap);
    function GetScreenShot(MonitorIndex: Integer): TBitmap;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  ClientSocket1 := TClientSocket.Create(Self);
  ClientSocket1.ClientType := ctNonBlocking;
  ClientSocket1.OnConnect := ClientSocket1Connect;
  ClientSocket1.OnDisconnect := ClientSocket1Disconnect;
  ClientSocket1.OnRead := ClientSocket1Read;
  ConnectionTimer.Enabled := True;
end;

procedure TForm1.ConnectionTimerTimer(Sender: TObject);
begin
  try
    if not ClientSocket1.Active then
    begin
      ClientSocket1.Address := '127.0.0.1';
      ClientSocket1.Port := 3434;
      ClientSocket1.Active := True;
      ShowMessage('Attempting to connect to the server...');
    end;
  except
    on E: Exception do
      ShowMessage('Connection attempt failed: ' + E.Message);
  end;
end;

procedure TForm1.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Timer1.Enabled := True;
  ConnectionTimer.Enabled := False;
  ShowMessage('Connected to server.');
end;

procedure TForm1.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Timer1.Enabled := False;
  ConnectionTimer.Enabled := True;
  ShowMessage('Disconnected from server.');
end;

procedure TForm1.ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
var
  ReceivedData: string;
begin
  ReceivedData := Socket.ReceiveText;
  HandleCommand(ReceivedData);
end;

procedure TForm1.HandleCommand(const aData: string);
var
  sl: TStringList;
  bmp: TBitmap;
  bytestream: TBytesStream;
  bytes: TBytes;
  base64Data: string;
begin
  sl := TStringList.Create;
  try
    sl.Delimiter := '|';
    sl.StrictDelimiter := True;
    sl.DelimitedText := aData;

    if sl[0] = 'ScreenShot' then
    begin
      bmp := GetScreenShot(StrToInt(sl[1]));
      SaveReceivedImageToTemp(bmp);
      try
        bytestream := TBytesStream.Create;
        try
          bmp.SaveToStream(bytestream);
          SetLength(bytes, bytestream.Size);
          bytestream.Position := 0;
          bytestream.ReadBuffer(bytes[0], bytestream.Size);
          base64Data := TNetEncoding.Base64.EncodeBytesToString(bytes);
          ClientSocket1.Socket.SendText('ScreenShot|' + base64Data);
        finally
          bytestream.Free;
        end;
      finally
        bmp.Free;
      end;
    end;
  finally
    sl.Free;
  end;
end;

procedure TForm1.SaveReceivedImageToTemp(aBitmap: TBitmap);
var
  TempPath, FileName: string;
begin
  TempPath := GetEnvironmentVariable('TEMP') + '\imagens_cliente';
  if not DirectoryExists(TempPath) then
    CreateDir(TempPath);

  FileName := TempPath + '\SendImage_' + FormatDateTime('yyyymmdd_hhnnss',
    Now) + '.bmp';

  aBitmap.SaveToFile(FileName);
end;

function TForm1.GetScreenShot(MonitorIndex: Integer): TBitmap;
var
  Monitor: TMonitor;
  DC: HDC;
begin
  Result := TBitmap.Create;
  try
    Monitor := Screen.Monitors[MonitorIndex];
    Result.PixelFormat := pf32bit;
    Result.Width := Monitor.Width;
    Result.Height := Monitor.Height;
    DC := GetDC(0);
    try
      BitBlt(Result.Canvas.Handle, 0, 0, Result.Width, Result.Height, DC,
        Monitor.Left, Monitor.Top, SRCCOPY);
      Result.Modified := True;
    finally
      ReleaseDC(0, DC);
    end;
  except
    Result.Free;
    Result := nil;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  ClientSocket1.Socket.SendText('Monitors|' + IntToStr(Screen.MonitorCount));
end;

end.
