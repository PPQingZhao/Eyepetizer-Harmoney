export interface EyeResponse<Result> {
  code: number;
  message: Message;
  result: Result;
}

export interface Message {
  content: '',
  action: ''
}