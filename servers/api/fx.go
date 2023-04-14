package api

import (
	"go.uber.org/fx"
	"go.uber.org/zap"

	"your_module/core"
	"your_module/servers"
	"your_module/servers/api/config"
	"your_module/services/fxapp"
)

// Transport contains all the dependencies used to run API transport layer.
var Transport = fx.Provide(
	func(conf *core.Config) *config.Config {
		return &conf.API
	},

	fx.Annotated{Name: "api", Target: NewHTTP},
)

// FxParams is the parameter used by uber-go/fx for the dependency injection.
type FxParams struct {
	fx.In
	Lifecycle  fx.Lifecycle
	Shutdowner fx.Shutdowner
	Logger     *zap.Logger
	Transport  servers.TCP `name:"api"`
}

// Run registers the API transport.
func Run(p FxParams) {
	fxServer := fxapp.NewTCPServer(p.Lifecycle, p.Shutdowner, p.Logger)
	fxServer.Run("http", p.Transport)
}
