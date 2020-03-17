defmodule MehrSchulferienWeb.Router do
  use MehrSchulferienWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/admin", MehrSchulferienWeb do
    pipe_through :browser

    # Maps
    resources "/locations", LocationController
    resources "/zip_codes", ZipCodeController
    resources "/zip_code_mappings", ZipCodeMappingController

    # Calendars
    resources "/religions", ReligionController
    resources "/holiday_or_vacation_types", HolidayOrVacationTypeController
    resources "/periods", PeriodController
  end

  scope "/", MehrSchulferienWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/land/:country_slug", CountryController, :show

    # School vacations
    get "/ferien/:country_slug/stadt/:city_slug", CityController, :show
    get "/ferien/:country_slug/bundesland/:federal_state_slug", FederalStateController, :show
    get "/ferien/:country_slug/schule/:school_slug", SchoolController, :show

    # Misc
    get "/landkreise-und-staedte/:country_slug/:federal_state_slug",
        FederalStateController,
        :county_show
  end

  scope "/api/v2", MehrSchulferienWeb.Api.V2 do
    pipe_through :api

    resources "/locations", LocationController, only: [:index, :show]
  end
end
