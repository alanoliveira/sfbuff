// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import ColorModeController from "./color_mode_controller"
application.register("color-mode", ColorModeController)

import FormHelperController from "./form_helper_controller"
application.register("form-helper", FormHelperController)

import I18nController from "./i18n_controller"
application.register("i18n", I18nController)

import MatchupsGroupByDateChartController from "./matchups_group_by_date_chart_controller"
application.register("matchups-group-by-date-chart", MatchupsGroupByDateChartController)

import RankedHistoryChartController from "./ranked_history_chart_controller"
application.register("ranked-history-chart", RankedHistoryChartController)

import TurboModalController from "./turbo_modal_controller"
application.register("turbo-modal", TurboModalController)
