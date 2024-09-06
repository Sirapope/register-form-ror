# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
FROM ruby:3.3.1-alpine AS base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" 

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    gcompat \
    git \
    nodejs \
    tzdata \
    yarn

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# # Precompile bootsnap code for faster boot times
# RUN SECRET_KEY_BASE=$(bundle exec rails secret) bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production
RUN SECRET_KEY_BASE=$(bundle exec rails secret) bundle exec rake assets:precompile
RUN SECRET_KEY_BASE=$(bundle exec rails secret) bundle exec rails db:create
# Final stage for app image
FROM base

# Install runtime dependencies
RUN apk add --no-cache \
    gcompat \
    sqlite \
    tzdata \
    vips

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Copy the entrypoint script
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh

# Entrypoint prepares the database.
ENTRYPOINT ["docker-entrypoint.sh"]
# Start the server by default, this can be overwritten at runtime
EXPOSE 80
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "80"]
