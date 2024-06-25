unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, pngimage, System.Win.ScktComp, System.NetEncoding, JPEG;

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
    procedure LogBase64ToFile(const Base64Data: string);
    function GetScreenShot(MonitorIndex: Integer): TBitmap;
    function CompressBitmapToJpeg(aBitmap: TBitmap;
      NewWidth, NewHeight: Integer): TJPEGImage; // Alterado para TJPEGImage
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const
  SERVER_ADDRESS = '127.0.0.1';
  SERVER_PORT = 3434;

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
      ClientSocket1.Address := SERVER_ADDRESS;
      ClientSocket1.Port := SERVER_PORT;
      ClientSocket1.Active := True;
      // Optionally show a connection attempt message
    end;
  except
    on E: Exception do
      // Optionally log the exception
  end;
end;

procedure TForm1.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Timer1.Enabled := True;
  ConnectionTimer.Enabled := False;
  // Optionally show a connection success message
end;

procedure TForm1.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Timer1.Enabled := False;
  ConnectionTimer.Enabled := True;
  // Optionally show a disconnection message
end;

procedure TForm1.ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
var
  ReceivedData: string;
begin
  ReceivedData := Socket.ReceiveText;
  HandleCommand(ReceivedData);
end;

function TForm1.CompressBitmapToJpeg(aBitmap: TBitmap;
  NewWidth, NewHeight: Integer): TJPEGImage;
var
  TempBitmap: TBitmap;
  JPEGImage: TJPEGImage;
begin
  TempBitmap := TBitmap.Create;
  try
    TempBitmap.PixelFormat := aBitmap.PixelFormat;
    TempBitmap.SetSize(NewWidth, NewHeight);

    // Using high-quality stretch method
    SetStretchBltMode(TempBitmap.Canvas.Handle, HALFTONE);
    StretchBlt(TempBitmap.Canvas.Handle, 0, 0, NewWidth, NewHeight,
      aBitmap.Canvas.Handle, 0, 0, aBitmap.Width, aBitmap.Height, SRCCOPY);

    JPEGImage := TJPEGImage.Create;
    try
      // Set JPEG quality (0-100)
      JPEGImage.CompressionQuality := 85;
      JPEGImage.Assign(TempBitmap);
      Result := JPEGImage;
    finally
      TempBitmap.Free;
    end;
  except
    TempBitmap.Free;
    raise;
  end;
end;

procedure TForm1.HandleCommand(const aData: string);
var
  sl: TStringList;
  bmp: TBitmap;
  JPEG: TJPEGImage;
  bytestream: TBytesStream;
  bytes: TBytes;
  Base64Data: string;
begin
  sl := TStringList.Create;
  try
    sl.Delimiter := '|';
    sl.StrictDelimiter := True;
    sl.DelimitedText := aData;

    if sl[0] = 'ScreenShot' then
    begin
      bmp := GetScreenShot(StrToInt(sl[1]));
      if Assigned(bmp) then
      begin
        JPEG := CompressBitmapToJpeg(bmp, bmp.Width div 3, bmp.Height div 3);
        // Correção aqui
        try
          bytestream := TBytesStream.Create;
          try
            JPEG.SaveToStream(bytestream);
            SetLength(bytes, bytestream.Size);
            bytestream.Position := 0;
            bytestream.ReadBuffer(bytes[0], bytestream.Size);
            Base64Data := TNetEncoding.Base64.EncodeBytesToString(bytes);
            LogBase64ToFile(Base64Data);
            ClientSocket1.Socket.SendText('ScreenShot|' + Base64Data);
          finally
            bytestream.Free;
          end;
        finally
          JPEG.Free;
        end;
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
  TempPath := IncludeTrailingPathDelimiter(GetEnvironmentVariable('TEMP')) +
    'imagens_cliente';
  if not DirectoryExists(TempPath) then
    CreateDir(TempPath);

  FileName := TempPath + '\SendImage_' + FormatDateTime('yyyymmdd_hhnnss',
    Now) + '.bmp';
  aBitmap.SaveToFile(FileName);
end;

procedure TForm1.LogBase64ToFile(const Base64Data: string);
var
  LogFileName: string;
  LogFile: TextFile;
begin
  LogFileName := IncludeTrailingPathDelimiter(GetEnvironmentVariable('TEMP')) +
    'base64_cliente_log.txt';
  AssignFile(LogFile, LogFileName);
  if FileExists(LogFileName) then
    Append(LogFile)
  else
    Rewrite(LogFile);
  try
    WriteLn(LogFile, Base64Data);
  finally
    CloseFile(LogFile);
  end;
end;

function TForm1.GetScreenShot(MonitorIndex: Integer): TBitmap;
var
  Monitor: TMonitor;
  DC: HDC;
begin
  Result := TBitmap.Create;
  try
    Monitor := Screen.Monitors[MonitorIndex];
    Result.PixelFormat := pf32bit; // Use 24-bit color depth
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
    on E: Exception do
    begin
      Result.Free;
      Result := nil;
      // Log the exception if necessary
    end;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  ClientSocket1.Socket.SendText('Monitors|' + IntToStr(Screen.MonitorCount));
end;

end.
