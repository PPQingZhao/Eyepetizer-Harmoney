export interface PageDataBean {
  page_info: Page_info;
  card_list: Card_list[];
}

export interface Data {
  page_url: string;
  page_url_parameter: string;
}

export interface Show {
  sdk: string;
  data: Data;
}

export class Tracking_data {
}

export interface Page_info {
  title: string;
  enable_share: boolean;
  base_link: string;
  page_label: string;
  tracking_data: Tracking_data;
  show_the_end: boolean;
}

export interface Margin {
  top: number;
  right: number;
  bottom: number;
  left: number;
}

export interface Top {
  color: string;
  margin: Margin;
  height: number;
}

export interface Bottom {
  color: string;
  margin: Margin;
  height: number;
}

export interface Separator_line {
  top: Top;
  bottom: Bottom;
}

export interface Padding {
  top: number;
  right: number;
  bottom: number;
  left: number;
}

export interface Background {
  color: string;
}

export interface Style {
  padding: Padding;
}

export interface Interaction {
  scroll: string;
}

export interface Metro_data {
  text: string;
}

export interface Params {
  data_type: string;
  uid: number;
  user_type: string;
  page_label: string;
}

export interface Data_source {
  label: string;
}

export interface Tracking_params {
  data_source: Data_source;
}

export interface Left {
  metro_id: number;
  metro_unique_id: string;
  type: string;
  style: Style;
  metro_data: Metro_data;
  tracking_data: Tracking_data;
  tracking_params: Tracking_params;
}

export interface Header {
  style: Style;
  left: Left[];
}

export interface Metro_list {
  metro_id: number;
  metro_unique_id: string;
  type: string;
  style: Style;
  metro_data: Metro_data;
  tracking_data: Tracking_data;
  tracking_params: Tracking_params;
}

export interface Body {
  metro_list: Metro_list[];
}

export interface Footer {
  style: Style;
}

export interface Card_data {
  header: Header;
  body: Body;
  footer: Footer;
}

export interface Card_list {
  card_id: number;
  card_unique_id: string;
  type: string;
  style: Style;
  interaction: Interaction;
  card_data: Card_data;
  tracking_data: Tracking_data;
}