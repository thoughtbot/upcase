SELECT
  subscriptions.id AS subscription_id,
  subscriptions.user_id,
  subscriptions.user_id AS owner_id,
  subscriptions.plan_type,
  subscriptions.plan_id,
  users.completed_welcome
FROM subscriptions
  INNER JOIN users ON users.id = subscriptions.user_id
WHERE subscriptions.deactivated_on IS NULL

UNION ALL

SELECT
  subscriptions.id as subscription_id,
  users.id AS user_id,
  subscriptions.user_id AS owner_id,
  subscriptions.plan_type,
  subscriptions.plan_id,
  users.completed_welcome
FROM teams
  INNER JOIN users ON users.team_id = teams.id
  INNER JOIN subscriptions ON subscriptions.id = teams.subscription_id
WHERE subscriptions.deactivated_on IS NULL
